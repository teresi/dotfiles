#!/usr/bin/env bash


# bash functions


notify () {
	# info message, green text prepended w/ "INFO  "
	echo -e "\e[32mINFO\t$1 \e[39m"
}


warn () {
	# warning message, yellow text prepended w/ "WARN  "
	echo -e "\e[33mWARN\t$1 \e[39m"
}


error () {
	# error message, red text prepended w/ "ERROR  "
	echo -e "\e[91mERROR\t$1 \e[39m"
}


update_repo_to_master () {
	# pull master on a repo, clone if necessary
	# NB use with care, do you really want to merge?
	local _REPO="$1"
	local _DIR="$2"
	notify "updating $_REPO"
	if [[ ! -d $_DIR ]]; then
		notify "\tgit clone $_REPO $_DIR"
		git clone $_REPO $_DIR
	fi
	notify "\tgit checkout master -C $_DIR"
	git -C "$_DIR" checkout master
	notify "\tgit pull origin master -C $_DIR"
	git -C "$_DIR" pull origin master
}


install_rust () {
	# TODO allow user to specifyh install dir
	_which_rust=`which rustup` || true
	if [[ -z $_which_rust ]]; then
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	fi
	. "$HOME"/.bashrc
	. "$HOME"/.cargo/env
	rustup update stable
}


are_packages_missing () {
	# print warning if any package in array $1 is not installed

	local _pkgs=( "$@" )
	local _missing=()

	for pkg in ${_pkgs[@]}; do \
		dpkg -s $pkg 2>/dev/null | grep -q "install ok installed" || _missing+=("$pkg")
	done
	if [ ${#_missing[@]} -eq 0 ]; then
		return 0
	fi

	error "you are missing packages!"
	error "please install:"
	echo ""
	echo "  ${_missing[@]}"
	echo ""
	return 1
}
