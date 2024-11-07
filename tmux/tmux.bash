#!/usr/bin/env bash

# tmux

# usage
#	./tmux.bash [install prefix]

# NOTE tmux requires ncurses/libevent
# since my machines typically have these already
# I've opted to not compile them in order to simplify linkage
# should revisit if this becomes an issue


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/../helpers.bash

_prefix=$1
_url=https://github.com/tmux/tmux.git
_dst=$_root_dir/tmux


source ~/.bashrc && are_packages_missing "bison libevent-dev libncurses-dev autotools-dev aclocal"

notify "updating tmux..."


notify "tmux fetch..."
update_repo_to_master $_url $_dst


notify "tmux configure..."
cd $_dst
# TODO handle libraries in prefix for libevent / libncurses
# see https://unix.stackexchange.com/questions/459671/how-do-i-build-tmux-from-source-without-root-access-with-a-custom-built-libevent
# https://github.com/tmux/tmux/wiki/Installing
export PKG_CONFIG_PATH+=:${_prefix}/lib/pkgconfig
sh autogen.sh
pkg-config --cflags --libs libevent --libs ncurses
./configure --prefix="$_prefix"

# NOTE can compile w/ our custom ncurses and libevent:
#	CPPFLAGS="-I$_prefix/include -I$_prefix/include/ncurses"
#	LDFLAGS="-L$_prefix/lib"
#
#	however, one would then need to update LD_LIBRARY_PATH to run tmux:
#		export LD_LIBRARY_PATH+=:$HOME/.local/lib
#	this is not an issue per se, we'd need to update it prior to calling
#	the dotfiles so that tmux/tpm calls succeed
#	we could also statically link with: --enable-static
#	FUTURE compile ncurses/libevent w/ static linkage enabled, then recompile tmux?
#	FUTURE use target specific variables or EXPORT_ALL_VARIABLES to export?

notify "tmux compile..."
make -j


if [ ! -d "$_prefix" ]; then
	error "cannot install tmux, prefix DNE:  $_prefix"
	sleep 3
	exit 1
fi
notify "tmux install..."
make install
notify "tmux installed to    $_prefix"
