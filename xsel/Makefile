#!/usr/bin/env make -S -f


# compile xsel
#
# an X session clipboard utility
#
# requires pkgconf, autoconf, automake, libtool


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
include ../helpers.mk

_src := xsel
_branch := master
_bin := $(_src)/src/xsel
_install := $(PREFIX)/bin/xsel
_url := https://github.com/kfish/xsel.git


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


.PHONY: uninstall
uninstall:
	$(call log_info,uninstall $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) uninstall; fi


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


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash
	cd $(_src) \
		&& ./autogen.sh


$(_src)/Makefile: $(_src)/Makefile.in
	$(call log_info,updating $@...)
	PKG_CONFIG_PATH+=:${PREFIX}/lib/pkgconfig \
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	make -C $(_src) -j all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
