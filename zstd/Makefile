#!/usr/bin/env make -S -f

# compile zstandard

# file compression tool

include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local

_url := https://github.com/facebook/zstd.git
_branch := dev
_src := zstd
_bin := $(_src)/programs/zstd
_install := $(PREFIX)/bin/zstd


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	make -C ${_src} clean
	rm -rf ${_bin}


.PHONY: uninstall
uninstall:
	make -C ${_src} uninstall


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_bin): git-hash
	$(call log_info,updating $@...)
	make -C ${_src} -j prefix=${PREFIX} all
	make -C ${_src} -j check


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C ${_src} -j prefix=${PREFIX} install
