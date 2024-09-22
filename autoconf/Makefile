#!/usr/bin/make -f

# compile autoconf

# autoconf is a tool that automatically configures source code
# it aims to provide a "reliable discovery of system-specific build and runtime information"
#
# see https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/autoconf.html
#
# for example, it checks your system for dependencies and generates Makefiles
# this is a common step used prior to calling `make` on gnu sources
#
# requires M4 (1.4.16 +)
# requires Perl (5.006 +)


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_dir := $(_root_dir)/autoconf
_bin := $(_dir)/bin/autoconf
_install := $(PREFIX)/bin/autoconf

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
_release_ver := 2.72
_release_tar := autoconf-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig
_release_tar_url := https://ftp.gnu.org/gnu/autoconf/autoconf-$(_release_ver).tar.gz
_release_sig_url := $(_release_tar_url).sig


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_dir) clean
	rm $(_release_sig)
	rm $(_release_tar)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_dir) uninstall


$(_gpg_key):
	curl -C - -o $(_gpg_key) $(_gpg_url)


$(_release_sig):
	curl -C - -o $(_release_sig) $(_release_sig_url)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_dir):  $(_release_sig) $(_release_tar) $(_gpg_key)
	gpg --verify $(_root_dir)/$(_release_sig) 2>&1 \
		| grep 'RSA' | awk '{print $$5}' \
		| xargs -I {} gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys {}
	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid autoconf sig"; exit $?)
	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid autoconf tar"; exit $?) \
		&& (mkdir -p $(_dir) && tar -xzvf $(_release_tar) -C $(_dir)/ --strip-components=1)


$(_bin): | $(_dir)
	cd $(_dir) && ./configure --prefix=$(PREFIX) && make -j
	@#not calling make check b/c 1.4.19 has a bug, fixed in 1.4.20? see https://bugs.gentoo.org/808749


$(_install): $(_bin)
	cd $(_dir) && make install
