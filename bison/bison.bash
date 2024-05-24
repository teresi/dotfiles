#!/usr/bin/env bash

# compile bison (GNU Parser Generator)
#
# parser to generate C / C+ / D / Java
#
# NB cloning from `https://git.savannah.gnu.org/git/bison.git` is possible
# but downloading from the mirror requires fewer dependencies, see README-hacking.md
#
# see
# https://github.com/akimd/bison/blob/master/

# via FTP:
#_ver=3.8.2
#_url="https://ftp.gnu.org/gnu/bison/bison-$_ver.tar.gz"
#_url_sig="https://ftp.gnu.org/gnu/bison/bison-$_ver.tar.gz.sig"
#_tar=$_root_dir/$(basename "$_url")
#_sig=$_root_dir/$(basename "$_url_sig")
#
# via git:
#_url=https://git.savannah.gnu.org/git/bison.git
#

_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/../helpers.bash

_prefix="$HOME"/.local
_overwrite="false"
_dst=$_root_dir/bison
_depends="autoconf automake autopoint flex gperf graphviz help2man texinfo valgrind"
_url=https://git.savannah.gnu.org/git/bison.git

_release_ver=3.8.2
_release_tar=$_root_dir/bison-${_release_ver}.tar.gz
_release_tar_url=https://ftp.gnu.org/gnu/bison/bison-${_release_ver}.tar.gz
_release_sig=$_root_dir/bison-${_release_ver}.tar.gz.sig
_release_sig_url=https://ftp.gnu.org/gnu/bison/bison-${_release_ver}.tar.gz.sig
_gnu_pub_url=https://ftp.gnu.org/gnu/gnu-keyring.gpg
_gnu_pub=/tmp/gnu-keyring.gpg

usage () {
	echo "$(basename $0) [OPTION]"
	echo ""
	echo "compile BISON"
	echo ""
	echo "-h, --help         show usage"
	echo "-p, --prefix       install prefix ($_prefix)"
#	echo "-l, --local        install even if bison is in PATH ($_overwrite)"
	echo ""
}

compile_from_source () {
	# compile bison from source
	#	this is more up to date than the release but requires more dependencies

	notify "checking package dependencies for bison..."
	are_packages_missing "$_depends"

	notify "bison fetch..."
	update_repo_to_master_2 $_url $_dst master
	notify "bison update submodules, please wait..."
	cd $_dst
	git submodule update --recursive --remote

	notify "bison compile..."
	cd $_dst
	./bootstrap || exit 1
	make distcheck || exit 1
	./configure --prefix $_prefix || exit 1
	make -j8
	make -j8 install
}

compile_from_release ()
{
	# compile bison from release
	#	this is not as up to date compare to source but requires fewer dependencies
	#	and is significantly faster to compile
	rm -f $_release_tar
	rm -rf $_dst
	notify "downloading bison..."
	curl -C - -o $_gnu_pub $_gnu_pub_url
	gpg --import $_gnu_pub
	curl -C - -o $_release_tar $_release_tar_url
	curl -C - -o $_release_sig $_release_sig_url
	notify "verifying bison..."
	gpg --verify $_release_sig $_release_tar || exit 1
	tar -xzvf $_release_tar -C $_root_dir
	mv $_root_dir/bison-${_release_ver} $_dst
	notify "configuring bison..."
	cd $_dst
	./configure --prefix $_prefix
	notify "compiling bison..."
	make -j4
	notify "installing bison to ${_prefix}..."
	make -j4 install
}


while [[ $# -gt 0 ]]
do
	key="${1}"
	case ${key} in
	-p|--prefix)
		_prefix=$2; shift 2;;
	-l|--local)
		_overwrite=1; shift;;
	-h|--help)
		usage; shift; exit 0;;
	*)    # unknown option
		shift;;
	esac
	shift
done

#notify "checking for bison..."
#bash -l -c 'source ~/.bashrc && type -t bison 2>&1 >/dev/null && exit 0 || exit 1'
#if [[ "$?" == 0 ]]; then
#	notify "bison already exists: `which bison`"
#	if [[ "$_overwrite" != 1 ]]; then
#		notify "skipping install, use --local to override"
#		exit 0
#	fi
#fi

#compile_from_source
compile_from_release
