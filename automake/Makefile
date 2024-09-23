#!/usr/bin/make -f

# compile automake

# tools for generating Makefiles for use w/ autoconf
#
# provides `automake` and `aclocal`
# provides
# aclocal:   generate aclocal.m4 from configure.in
# automake:  generate Makefile.in from Makefile.am


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_dir := $(_root_dir)/automake
_bin := $(_dir)/bin/automake
_install := $(PREFIX)/bin/automake

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
_release_ver := 1.16.5
_release_tar := automake-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig
_release_tar_url := https://mirrors.ocf.berkeley.edu/gnu/automake/$(_release_tar)
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
	curl -o $(_release_sig) $(_release_sig_url)


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


$(_install): $(_bin)
	cd $(_dir) && make install
