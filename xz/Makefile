#!/usr/bin/env make -S -f

# compile XZ

# XZ utils
# compression utility and library

# BINARIES PROVIDED
# xz, xzcat, etc.

# LIBRARIES PROVIDED
# liblzma

# REQUIRES
# make


include ../helpers.mk
PREFIX ?= $(HOME)/.local/
SHELL ?= /bin/bash


_url := https://github.com/tukaani-project/xz.git
_branch := v5.8
_src := xz
_bin := $(_src)/src/xz/xz
_install := $(PREFIX)/bin/xz


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi


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
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	make -C $(_src) -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) PREFIX=$(PREFIX) install
