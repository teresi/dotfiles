#!/usr/bin/env make -S -f


# compile xclip
#
# an X session clipboard utility
#
# requires xmu header (libxmu-dev on ubuntu)


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
include ../helpers.mk

_url := https://github.com/astrand/xclip.git
_branch := 0.13
_src := xclip
_bin := $(_src)/xclip
_install := $(PREFIX)/bin/xclip


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	rm -rf $(PREFIX)/bin/xclip*
	rm -rf $(PREFIX)/share/man/man1/xclip*


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
	PKG_CONFIG_PATH+=:${PREFIX}/lib/pkgconfig \
		cd $(_src) \
		&& autoreconf -fiv \
		&& autoupdate


$(_src)/Makefile: $(_src)/Makefile.in
	PKG_CONFIG_PATH+=:${PREFIX}/lib/pkgconfig \
		cd $(_src) \
		&& ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	ldconfig -p | grep -q libXmu || (echo libxmu-dev is required, not found; exit 1;)
	make -C $(_src) -j all


$(_install): $(_bin)
	make -C $(_src) install
