#!/usr/bin/env bash

# install or update alacritty
#   installs rust and other dependencies
#   NB this will update your rust compiler

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $ROOT_DIR/helpers.bash

ALA_SRC="https://github.com/alacritty/alacritty.git"
ALA_SRC_DIR="$HOME/alacritty"
DEPENDS=( cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 )
INSTALL_DIR="$HOME/.local/bin"
BASH_COMPLETION="$ALA_SRC_DIR/extra/completions/alacritty.bash"

is_installed () {
	# return 0 if package is installed
	_pkg="$1"
	dpkg -s $1 | grep -q "^Status: install ok installed"
	return $?
}

install_pkgs () {
	# check an array of packages and install them if not already installed
	_dependencies=("$@")
	for pkg in "${_dependencies[@]}"
	do
		$(is_installed "$pkg")
		if [[ $? != 0 ]]; then
			warn "$pkg not installed!"
			set -x
			sudo apt install "$pkg"
			set +x
		fi
	done
}

install_rust () {
	# install and update rust to stable
	set -x
	_which_rust=`which rustup` || true
	if [[ -z $_which_rust ]]; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	fi
	. "$HOME"/.bashrc
	. "$HOME"/.cargo/env
	rustup override set stable
	rustup update stable
}

set -e

notify "updating alacritty source..."
update_repo_to_master "https://github.com/alacritty/alacritty.git" "$ALA_SRC_DIR"

notify "installing dependencies..."
install_pkgs "${DEPENDS[@]}"
notify "  dependencies installed!"

notify "installing / updating rust..."
install_rust
notify "  rust installed!"

notify "building alacritty..."
cd "$ALA_SRC_DIR"
cargo build --release

notify "updating terminfo..."
if [[ $(infocmp alacritty > /dev/null) != 0 ]]; then
	set -x
	mkdir -p "$HOME/.terminfo"
	tic -xe alacritty,alacritty-direct extra/alacritty.info
	set +x
fi

notify "installing alacritty to $INSTALL_DIR..."
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

notify "installing bash completions..."
if grep -q "source $BASH_COMPLETION" ~/.bashrc; then
	# this requires one to no delete the source
	# done this way b/c installing to '~/.bash_completion'
	# cause extraneous warning messages when sourcing bashrc
	echo "source $BASH_COMPLETION" >> ~/.bashrc
fi
