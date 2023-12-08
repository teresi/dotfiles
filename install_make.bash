#!/usr/bin/env bash

# install gnu/make

_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/helpers.bash

version=4.4.1
prefix="$HOME/.local"
make_tar_uri="https://ftp.gnu.org/gnu/make/make-${version}.tar.gz"
make_sig_uri="https://ftp.gnu.org/gnu/make/make-${version}.tar.gz.sig"
make_key_uri=https://ftp.gnu.org/gnu/gnu-keyring.gpg
parent=/tmp

make -v &> /dev/null
if [[ $? == 0 ]]; then
	make_version=$(make -v | grep "^GNU Make" | sed ' s/^GNU Make //')
	if [[ "$make_version" == "$version" ]]; then
		notify "gnu/make ($make_version) is up to date:  $(which make)"
		exit 0
	fi
fi


notify "compling gnu/make $version to $prefix..."
notify "    updating from $make_version to $version"

set -ex

make_tar=${parent}/$(basename $make_tar_uri)
curl $make_tar_uri -o /tmp/$(basename $make_tar_uri)

make_sig=${parent}/$(basename $make_sig_uri)
curl $make_sig_uri -o /tmp/$(basename $make_sig_uri)

make_key=${parent}/$(basename $make_key_uri)
curl $make_key_uri -o /tmp/$(basename $make_key_uri)

$(gpgv --keyring $make_key $make_sig $make_tar)
if [[ $? != 0 ]]; then
	error "could not verify signature for make, see:"
	error "  $make_tar_uri"
	error "  $make_key_uri"
	error "  $make_sig_uri"
	exit 1
fi

# FUTURE if `make` is not available, one can call configure (see readme)
# and then `sh build.sh` to creake `make` in the current dir,
# then proceed to call make install etc

tar -xzvf $make_tar -C $parent
cd "$parent/make-$version"
./configure --prefix "$prefix"
make -j
make install


notify "compling gnu/make $version to $prefix...    COMPLETE!"
