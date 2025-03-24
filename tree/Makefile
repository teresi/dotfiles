#!/usr/bin/make -f

# compile tree

# displays contents of a directory


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
include ../helpers.mk

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

_src := unix-tree
_bin := $(_src)/tree
_install := $(PREFIX)/bin/tree

_release_ver := 2.1.3
_release_tar := unix-tree-$(_release_ver).tar.xz
_release_tar_url :=  https://gitlab.com/OldManProgrammer/unix-tree/-/archive/2.1.3/unix-tree-2.1.3.tar.bz2
_md5_sum := 9be227932ab457c29f33196544cd1e13


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: uninstall
uninstall:
	rm $(PREFIX)/bin/tree


.PHONY: download
download: $(_src)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; exit $?) \
		&& tar -xf $(_release_tar) \
		&& mv $(_src)-$(_release_ver) $(_src) \
		&& touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	$(MAKE) -C $(_src) -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	$(MAKE) -C $(_src) PREFIX=$(PREFIX) MANDIR=$(PREFIX)/share/man install
