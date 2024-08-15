#!/usr/bin/env bash

# add symlink at $2 pointing to target $1
#      Backup file at $1 if exists and is not a symlink

#      1    target of symlink
#      2    linkname of symlink


# using `mv` instead of `cp --backup` b/c the latter was nesting backups on repeated calls
# using `mv` instead of `cp` b/c we don't want the original there when linking

if [ -e ${2} ] &&  [ ! -L ${2} ]
then
	mv ${2%/} ${2%/}.bak
fi

if [ -z "${NO_SYMLINKS}" ]
then
	echo -e "\e[32mINFO\tlinking $1 --> $2\e[39m"
	mkdir -p $(dirname ${2})
	ln -sfn ${1} ${2}
else
	echo -e "\e[32mINFO\tcopying $1 --> $2\e[39m"
	cp ${1} ${2}
fi
