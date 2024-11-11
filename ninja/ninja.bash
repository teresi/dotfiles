#!/usr/bin/env bash

# ninja-build

# usage
#	./ninja.bash [install prefix]


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/../helpers.bash

_prefix=$1
_url=https://github.com/ninja-build/ninja.git
_dst=$_root_dir/ninja


notify "updating ninja..."


notify "ninja fetch..."
update_repo_to_master $_url $_dst


notify "ninja configure..."
cd $_dst
cmake -Bbuild-cmake


notify "ninja compile..."
cmake --build build-cmake -j


if [ ! -d "$_prefix" ]; then
	error "cannot install ninja, prefix DNE:  $_prefix"
	sleep 3
	exit 1
fi

notify "ninja install..."
cp $_dst/build-cmake/ninja $_prefix/ninja
notify "ninja installed to    $_prefix"
