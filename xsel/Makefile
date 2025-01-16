#!/usr/bin/make -f


# compile xsel
#
# an X session clipboard utility
#
# requires pkgconf, autoconf, automake, libtool


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
include ../helpers.mk

_src := xsel
_bin := $(_src)/src/xsel
_install := $(PREFIX)/bin/xsel
_url := https://github.com/kfish/xsel.git
_branch := master


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
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: uninstall
uninstall:
	$(call log_info,uninstall $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) uninstall; fi


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	export PKG_CONFIG_PATH+=:${PREFIX}/lib/pkgconfig \
		&& cd $(_src) \
		&& sh autogen.sh \
		&& ./configure --prefix=$(PREFIX) \
		&& make -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
