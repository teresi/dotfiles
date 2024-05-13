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

[ -z "$_branch" ] && _branch=master
[ -w "$_dest" ] || error "cannot write to $_dest"

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
