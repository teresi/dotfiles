#!/usr/bin/env bash


# compile cpython
#  installs by default to ~/.local/bin


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/helpers.bash
notify "compling cpython..."


_dry_run=""
_cpy_ver=3.11
_cpy_url=https://github.com/python/cpython.git
_cpy_src="$HOME"/cpython
_cpy_pre="$HOME"/.local
_cpy_dep=(build-essential gdb lcov pkg-config libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev lzma lzma-dev tk-dev uuid-dev zlib1g-dev)


usage () {
	echo "$(basename $0) [OPTION]"
	echo ""
	echo "compile cpython"
	echo ""
	echo "-h, --help         show usage"
	echo "-p, --python       python version ($_cpy_ver)"
	echo "--prefix           installation prefix ($_cpy_pre)"
	echo ""
}


while [[ $# -gt 0 ]]
do
	key="${1}"
	case ${key} in
	-p|--python)
		_cpy_ver=$2; shift 2;;
	--prefix)
		_cpy_pre=$2; shift 2;;
	--dry-run)
		_dry_run=1; shift;;
	-h|--help)
		usage; shift;;
	*)    # unknown option
		shift;;
	esac
	shift
done


notify "checking dependencies..."
are_packages_missing "${_cpy_dep[@]}"


notify "updating cpython source..."
if [ ! -d $_cpy_src ]; then
	git clone $_cpy_url $_cpy_src --branch $_cpy_ver --single-branch
fi
cd $_cpy_src && git fetch && git checkout $_cpy_ver && git reset --hard origin/$_cpy_ver


if [ -n "$_dry_run" ]; then
	notify "skipping compilation, dry-run is set"
	exit 0
fi

notify "compiling..."
make -C $_cpy_src clean
cd $_cpy_src && ./configure --prefix="$_cpy_pre" --enable-optimizations --with-lto
make -C $_cpy_src all -j
make -C $_cpy_src altinstall -j
