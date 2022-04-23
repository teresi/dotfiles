#!/usr/bin/env bash


# bash functions


notify () {
	# info message, green text prepended w/ "INFO  "
	echo -e "\e[32mINFO  $1 \e[39m"
}


warn () {
	# warning message, yellow text prepended w/ "WARN  "
	echo -e "\e[33mWARN  $1 \e[39m"
}


error () {
	# error message, red text prepended w/ "ERROR  "
	echo -e "\e[91mINFO  $1 \e[39m"
}


update_repo_to_master () {
	# pull master on a repo, clone if necessary
	# NB use with care, do you really want to merge?
	_REPO="$1"
	_DIR="$2"
	notify "cloning or fetching: $_REPO"
	if [[ -d $_DIR ]]; then
		git -C "$_DIR" fetch
	else
		git clone $_REPO $_DIR
	fi
	notify "git checkout master -C $_DIR"
	git -C "$_DIR" checkout master
	notify "git pull origin master -C $_DIR"
	git -C "$_DIR" pull origin master
}
