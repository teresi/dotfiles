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
	# clone | fetch | reset to bring a git repo up to date
	#
	#	1	repo url
	#	2	target directory
	#	3	branch or tag (master)
	#	4	depth (all)
	#
	# NB only call reset if it's not up to date,
	#    so that we can use the .git dir timestamp in Makefile rules,
	#    since the timestamp will change when git reset is called

	notify "updating repository..."
	local _url=$1
	local _dest=$2
	local _branch=$3
	local _depth=$4

	[ -z "$_branch" ] && _branch=master
	[ -n "$_depth" ] && _depth="--depth $_depth"

	notify "    repo directory:  $_dest"
	notify "    repo url:        $_url"
	notify "    repo branch:     $_branch"
	notify "    repo depth:      $_depth"

	if [ ! -d "$_dest" ]; then notify "cloning $url to $_dest"; fi;
	if [ ! -d "$_dest" ];
		then git clone $_depth --branch $_branch $_url $_dest;
	fi;
	# NB `git status` updates the .git folder for some reason,
	#    so don't call it here or else it will update even if there are no changes!

	notify "    fetching..."
	# fetch, checkout, reset if necessary
	# set the origin for the branch in case a shallow clone was used
	# fetch the branch specifically in case a shallow clone was used
	git -C $_dest fetch $_depth origin $_branch

	notify "    updating to $_branch..."
	_local=$(git -C $_dest rev-list -n 1 HEAD)
	# use ls-remote b/c we need to handle tags AND branches
	_remote=$(git -C $_dest ls-remote origin refs/heads/${_branch} | cut -f1)
	if [ -z "$_remote" ]; then
	# dereference b/c we need the OID of the commit associated w/ the tag, not the object ID of the tag itself
	# NOTE sometimes you can get two lines? this happens w/ libevent
	#      and it won't actually checkout the remote hash directly
		_remote=$(git -C $_dest show-ref --hash --dereference refs/tags/${_branch} | head -n 1)
	fi
	if [ -z "$_remote" ]; then
		warn "could not find commit for branch/tag: ${_branch} at ${_dest}"
	fi
	notify "    local commit is at  $_local"
	notify "    remote commit is at $_remote"
	if [ "${_local}" != "${_remote}" ]; then
		notify "    updating to ${_branch}... checkout"
		git -C $_dest remote set-branches origin ${_branch}
		git -C $_dest fetch $_depth origin $_branch
		git -C $_dest checkout $_branch
		git -C $_dest fetch --tags || true
		if [ "$?" != "0" ]; then
			error "failed to checkout branch $_branch for repo $_dest"
			return 1
		fi
		# @ means the current branch, {u} means upstream
		git -C ${_dest} reset --hard ${_remote}
	else
		notify "    updating to $_branch... already up to date"
	fi
	echo ""
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
	error "    some targets may not succeed,"
	error "    or some important programs might be missing"
	error "please install:"
	echo ""
	echo "  ${_missing[@]}"
	echo ""
	sleep 4
	return 1
}

are_packages_missing_warn () {
	# print warning if any package in array $1 is not installed

	local _pkgs=( "$@" )
	local _missing=()

	for pkg in ${_pkgs[@]}; do \
		dpkg -s $pkg 2>/dev/null | grep -q "install ok installed" || _missing+=("$pkg")
	done
	if [ ${#_missing[@]} -eq 0 ]; then
		return 0
	fi

	warn "missing package, the following is recommended:"
	echo ""
	echo "  ${_missing[@]}"
	echo ""
	sleep 4
	return 1
}
