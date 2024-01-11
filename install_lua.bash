#!/usr/bin/env bash

# compile lua


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/helpers.bash

_prefix="$HOME"/.local
_overwrite="false"
_lua_ver=5.4.6
_lua_uri=https://www.lua.org/ftp/lua-5.4.6.tar.gz
_lua_sha=7d5ea1b9cb6aa0b59ca3dde1c6adcb57ef83a1ba8e5432c0ecd06bf439b3ad88
_lua_dst=/tmp/lua-$_lua_ver


usage () {
	echo "$(basename $0) [OPTION]"
	echo ""
	echo "compile cpython"
	echo ""
	echo "-h, --help         show usage"
	echo "-p, --prefix       install prefix ($_prefix)"
	echo "-f, --force        install even if lua is up to date ($_overwrite)"
	echo ""
}


while [[ $# -gt 0 ]]
do
	key="${1}"
	case ${key} in
	-p|--prefix)
		_prefix=$2; shift 2;;
	-f|--force)
		_overwrite=1; shift;;
	-h|--help)
		usage; shift;;
	*)    # unknown option
		shift;;
	esac
	shift
done


# NB use lua -v >3&1, else it won't get captured by the variable
lua -v &> /dev/null
if [[ "$?" == 0 ]]; then
	current_version=$(lua -v | grep -oEi "^Lua ([0-9]\.[0-9]\.[0-9])" | sed 's/^Lua //')
	if [[ "$current_version" == "$_lua_ver" ]]; then
		notify "lua $_lua_ver is up to date:  $(which lua)"
		if [[ "$_overwrite" == "false" ]]; then
			exit 0
		fi
	fi
fi


_lua_tar=/tmp/$(basename "$_lua_uri")
notify "downloading lua..."
cd /tmp
curl "$_lua_uri" -o "$_lua_tar"
_sha=$( sha256sum $_lua_tar | awk '{ print $1 }')
echo $_sha
if [[ "$_sha" != "$_lua_sha" ]]; then
	error "could not download lua, sha256 mismatch!  $_lua_tar"
	error "please check URI / SHA:"
	error "  lua uri:    $_lua_uri"
	error "  lua sha:    $_lua_sha"
	exit 1
else
	notify "downloading lua...  SUCCESS"
fi


notify "compiling  ..."

set -ex
tar -xzf $_lua_tar -C /tmp
cd $_lua_dst
make all test

notify "compiling  ... SUCCESS"
notify "installing ..."

make install INSTALL_TOP="$_prefix"

notify "installing ... SUCCESS"
notify "lua is at $(which lua)"
