#!/usr/bin/env bash

# clone | fetch | reset to bring a git repo up to date
#
#	1	repo url
#	2	target directory
#	3	branch (master)
#
# NB only call reset if it's not up to date,
#    so that we can use the .git dir timestamp in Makefile rules,
#    since the timestamp will change when git reset is called


_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash


_url=$1
_dest=$2
_branch=$3

update_repo_to_master $_url $_dest $_branch
