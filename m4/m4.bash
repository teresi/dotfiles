#!/usr/bin/env bash

# compile GNU M4
#
# macro processor
#
# see
# https://www.gnu.org/software/m4/m4.html
#


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/../helpers.bash

_prefix="$HOME"/.local
_dst=$_root_dir/m4
_depends="tar curl"
_gpg_key=${_root_dir}/gnu-keyring.gpg
_gpg_url=https://ftp.gnu.org/gnu/gnu-keyring.gpg
_release_ver=1.4.19
_release_sig=${_root_dir}/m4-${_release_ver}.tar.gz.sig
_release_sig_url=https://mirrors.ibiblio.org/gnu/m4/m4-1.4.19.tar.gz.sig
_release_sig_key=71C2CC22B1C4602927D2F3AAA7A16B4A2527436A
_release_tar=${_root_dir}/m4-${_release_ver}.tar.gz
_release_tar_url=https://mirrors.ibiblio.org/gnu/m4/m4-1.4.19.tar.gz


usage () {
	echo "$(basename $0) [OPTION]"
	echo ""
	echo "compile M4"
	echo ""
	echo "-h, --help         show usage"
	echo "-p, --prefix       install prefix ($_prefix)"
	echo ""
}

compile_from_release ()
{

	notify "checking package dependencies for bison..."
	are_packages_missing "$_depends"

	notify "downloading M4..."
	rm -f $_release_tar
	rm -rf $_dst

	curl -C - -o $_gpg_key $_gpg_url
	curl -C - -o $_release_tar $_release_tar_url
	curl -C - -o $_release_sig $_release_sig_url

	notify "verifying M4..."
	gpg --verify --keyring $_gpg_key $_release_sig || (error "could not verify M4 sig"; exit 1)
	gpg --verify $_release_sig $_release_tar || (error "could not verify M4 tar"; exit 1)

	notify "unpack M4..."
	tar -xzvf $_release_tar -C $_root_dir
	mv $_root_dir/m4-${_release_ver} $_dst

	notify "compile M4..."
	cd $_dst
	./configure --prefix=$_prefix
	make && make check && make install
}


while [[ $# -gt 0 ]]
do
	key="${1}"
	case ${key} in
	-p|--prefix)
		_prefix=$2; shift 2;;
	-h|--help)
		usage; shift; exit 0;;
	*)    # unknown option
		shift;;
	esac
	shift
done


compile_from_release
