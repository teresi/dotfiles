#!/usr/bin/env make -S -f

# compile zstandard

# file compression tool

include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local

_url := https://github.com/facebook/zstd.git
_branch := dev
_src := zstd
_bin := zstd
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


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


.PHONY: download
download: repo


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	make -C ${_src} prefix=${PREFIX} all
	make -C ${_src} check


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C ${_src} prefix=${PREFIX} install
