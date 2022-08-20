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
	if [[ -d $_DIR ]]; then
		notify "\tgit -C $_DIR fetch"
		git -C "$_DIR" fetch
	else
		notify "\tgit clone $_REPO $_DIR"
		git clone $_REPO $_DIR
	fi
	notify "\tgit checkout master -C $_DIR"
	git -C "$_DIR" checkout master
	notify "\tgit pull origin master -C $_DIR"
	git -C "$_DIR" pull origin master
}
