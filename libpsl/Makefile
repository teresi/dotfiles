#!/usr/bin/env make -S -f

# libpsl
# C library to handle the Public Suffix List

# psl			# binary
# libpsl.so		# lib
#
# dependency of CURL

# REQUIRES
#	libidn2
#	libunistring
#	pkg-config (installed to HOME!)
#	python

include ../helpers.mk
PREFIX ?= $(HOME)/.local
SHELL ?= /bin/bash

_url := https://github.com/rockdaboot/libpsl.git
_branch := master
_src := libpsl
_bin := $(_src)/tools/psl
_install := $(PREFIX)/bin/psl


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	$(call log_info,uninstall $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi


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
	@# using `autoreconf -fi` fails, but `autoreconf -i` succeeds
	cd $(_src) \
		&& LDFLAGS+="-L$$HOME/.local/lib" CFLAGS+="-I$$HOME/.local/include" \
			./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	$(call log_info,    checking submodules...)
	make -C $(_src) -j
	make -C $(_src) -j check


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) install
