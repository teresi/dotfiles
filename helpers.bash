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


# TODO candidate for deletion
#update_repo_to_master () {
#	# pull master on a repo, clone if necessary
#	# NB use with care, do you really want to merge?
#	local _REPO="$1"
#	local _DIR="$2"
#	notify "updating $_REPO"
#	if [[ ! -d $_DIR ]]; then
#		notify "\tgit clone $_REPO $_DIR"
#		git clone $_REPO $_DIR
#	fi
#	notify "\tgit checkout master -C $_DIR"
#	git -C "$_DIR" checkout master
#	notify "\tgit pull origin master -C $_DIR"
#	git -C "$_DIR" pull origin master
#}

update_repo_to_master () {
	# clone | fetch | reset to bring a git repo up to date
	#
	#	1	repo url
	#	2	target directory
	#	3	branch (master)
	#
	# NB only call reset if it's not up to date,
	#    so that we can use the .git dir timestamp in Makefile rules,
	#    since the timestamp will change when git reset is called

	local _url=$1
	local _dest=$2
	local _branch=$3

	[ -z "$_branch" ] && _branch=master

	notify "updating $_url -> $_dest"
	if [ ! -d "$_dest" ]; then git clone $_url $_dest; fi;
	git -C $_dest status 2>/dev/null || git clone $_url $_dest || true

	# fetch, checkout, reset if necessary
	notify "updating to $_branch for repo at $_dest"
	git -C $_dest fetch
	git -C $_dest checkout $_branch

	_local=$(git -C $_dest rev-parse @)
	_remote=$(git -C $_dest rev-parse @{u})
	if [ "$_local" != "$_remote" ]; then
		notify "resetting to origin/$_branch for repo at $_dest"
		git -C $_dest reset --hard origin/$_branch
	fi
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
	sleep 1
	return 1
}
