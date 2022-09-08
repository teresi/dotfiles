#!/usr/bin/env bash

# install or update alacritty
#   installs rust and other dependencies
#   NB this will update your rust compiler


_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
notify "compling alacritty..."


# FUTURE make these paths configurable?
ALA_SRC="https://github.com/alacritty/alacritty.git"
ALA_SRC_DIR="$HOME/alacritty"
DEPENDS=( cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 )
INSTALL_DIR="$HOME/.local/bin/"
BASH_COMPLETION="$ALA_SRC_DIR/extra/completions/alacritty.bash"
INSTALL=0


is_installed () {
	# return 0 if package is installed
	_pkg="$1"
	_pkg_installed=$(dpkg-query -W --showformat='${status}\n' $_pkg 2>/dev/null| grep "install ok installed") 2>/dev/null
	if [ "" = "$_pkg_installed" ]; then
		return 1
	else
		return 0
	fi
}


check_pkgs () {
	# check an array of packages and install them if not already installed
	_dependencies=("$@")
	_success="true"
	for pkg in "${_dependencies[@]}"
	do
		$(is_installed "$pkg") || warn "missing package! $pkg" _success="false"
	done
	if [ "false" = "$_success" ]; then
		return 1
	else
		return 0
	fi
}


install_rust () {
	# install and update rust to stable
	_which_rust=`which rustup` || true
	if [[ -z $_which_rust ]]; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	fi
	. "$HOME"/.bashrc
	. "$HOME"/.cargo/env
	rustup override set stable
	rustup update stable
}


usage () {
	echo "$(basename $0) [OPTION]"
	echo ""
	echo "compile alacritty to user space"
	echo ""
	echo "-h, --help         show usage"
	echo "-a, --apt          install apt dependencies"
	echo ""
}


while [[ $# -gt 0 ]]
do
	key="${1}"
	case ${key} in
	-a|--apt)
		INSTALL=1
		shift
		shift
		;;
	-h|--help)
		usage
		shift
		;;
	*)    # unknown option
		shift
		;;
	esac
	shift
done


set -e

notify "updating alacritty source..."
update_repo_to_master "$ALA_SRC" "$ALA_SRC_DIR"

if [ "$INSTALL" = 1 ]; then
	notify "installing dependencies..."
	set -x
	sudo apt install "${DEPENDS[@]}"
	set +x
fi
check_pkgs "${DEPENDS[@]}" || error "missing dependencies... exit" usage exit 1

notify "installing / updating rust..."
install_rust
notify "  rust installed!"

notify "building alacritty..."
cd "$ALA_SRC_DIR"
cargo build -j $(nproc) --release

notify "updating terminfo..."
if [[ $(infocmp alacritty > /dev/null) != 0 ]]; then
	set -x
	mkdir -p "$HOME/.terminfo"
	tic -xe alacritty,alacritty-direct extra/alacritty.info
	set +x
fi

notify "installing bash completions..."
if grep -q "source $BASH_COMPLETION" ~/.bashrc; then
	# this requires one to no delete the source
	# done this way b/c installing to '~/.bash_completion'
	# cause extraneous warning messages when sourcing bashrc
	echo "source $BASH_COMPLETION" >> ~/.bashrc
fi

notify "installing alacritty to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
cp target/release/alacritty "$INSTALL_DIR"

# TODO add extras if a sudo flag is set
# TODO install desktop entry
#sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
#sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
#sudo desktop-file-install extra/linux/Alacritty.desktop
#sudo update-desktop-database
# TODO install manual
#sudo mkdir -p /usr/local/share/man/man1
#gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
#gzip -c extra/alacritty-msg.man | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null

