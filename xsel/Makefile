#!/usr/bin/make -f


# compile xsel
#
# an X session clipboard utility
#
# requires pkgconf, autoconf, automake, libtool


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
include ../helpers.mk

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_dir := $(_root_dir)/xsel
_bin := $(_dir)/src/xsel
_install := $(PREFIX)/bin/xsel


_repo_url := https://github.com/kfish/xsel.git


# https://tgebarowski.github.io/2008/08/31/problem-with-pkg_check_modules-under-mac-os-x/
# need pkg-conf
# can use host aclocal:
#
# aclocal -I ~/.local/share/aclocal
# autoheader && automake && autoconf && ./configure
#
# OR, install pkg-conf, and use custom aclocal
# https://github.com/pkgconf/pkgconf


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: check
check:
	@# TODO xsel requires x11 libraries
	@# see https://www.linuxfromscratch.org/blfs/view/svn/x/x7lib.html
	@# see https://packages.debian.org/sid/libx11-dev
	ldconfig -p | grep -q x11 || (echo libx11-dev is required, not found; exit 1;)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_dir) clean
	rm $(_release_sig)
	rm $(_release_tar)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_dir) uninstall


$(_bin):
	$(call git_clone_fetch_reset,$(_repo_url),$(_dir),master)
	export PKG_CONFIG_PATH+=:${PREFIX}/lib/pkgconfig \
		&& cd $(_dir) \
		&& sh autogen.sh \
		&& ./configure --prefix=$(PREFIX) \
		&& make -j


$(_install): $(_bin)
	make -C $(_dir) install
