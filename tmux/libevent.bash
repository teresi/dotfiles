#!/usr/bin/env bash

# libevent
#	library for executing a callback given a fileback descriptor event, signal, or etc

# usage
#	./libevent.bash [install prefix]


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/../helpers.bash

_prefix=$1
_url=https://github.com/libevent/libevent.git
_dst=$_root_dir/libevent


notify "updating libevent..."


are_packages_missing cmake


notify "libevent fetch..."
update_repo_to_master $_url $_dst


notify "libevent configure..."
cd $_dst
rm -rf build && mkdir build && cd build
cmake \
	-DCMAKE_INSTALL_PREFIX="$_prefix" \
	..


notify "libevent compile..."
make -j


if [ ! -d "$_prefix" ]; then
	error "cannot install libevent, prefix DNE:  $_prefix"
	sleep 3
	exit 1
fi
notify "libevent install..."
make install
notify "libevent installed to    $_prefix"
