#!/usr/bin/make -f


# compile xclip
#
# an X session clipboard utility
#
# requires xmu header (libxmu-dev on ubuntu)


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
include ../helpers.mk

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

_url := https://github.com/astrand/xclip.git
_branch := master

_src := xclip
_bin := $(_src)/xclip
_install := $(PREFIX)/bin/xclip


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: check
check:
	@# libx11-dev, libxt-dev, libxmu-dev...
	@# NOTE other dependencis may be required
	ldconfig -p | grep -q libXmu || (echo libxmu-dev is required, not found; exit 1;)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_src) clean


.PHONY: uninstall
uninstall:
	rm -rf $(PREFIX)/bin/xclip*
	rm -rf $(PREFIX)/share/man/man1/xclip*


$(_install): $(_bin)
	make -C $(_src) install


$(_src)/.git: | repo


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_bin): $(_src)/.git
	export PKG_CONFIG_PATH+=:${PREFIX}/lib/pkgconfig \
		&& cd $(_src) \
		&& autoreconf -fiv \
		&& autoupdate \
		&& ./configure --prefix=$(PREFIX) \
		&& make -j
