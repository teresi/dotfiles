#!/usr/bin/env bash

# ncurses
#	library for terminal-independent handling of character screens

# usage
#	./ncurses.bash [install prefix]


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/../helpers.bash

_prefix=$1
_url=https://github.com/mirror/ncurses.git
_dst=$_root_dir/ncurses


notify "updating ncurses..."


notify "ncurses fetch..."
update_repo_to_master $_url $_dst


notify "ncurses configure..."
cd $_dst
./configure --prefix="$_prefix" \
	--with-shared \
	--with-termlib \
	--enable-pc-files \
	--with-pkg-config-libdir=$_prefix/lib/pkgconfig


notify "ncurses compile..."
make -j


if [ ! -d "$_prefix" ]; then
	error "cannot install ncurses, prefix DNE:  $_prefix"
	sleep 3
	exit 1
fi
notify "ncurses install..."
make install
notify "ncurses installed to    $_prefix"
