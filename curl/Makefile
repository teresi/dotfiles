#!/usr/bin/make -f

# compile curl

# CURL up/downloads files given URLs


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_install := $(PREFIX)/bin/curl
_url := https://github.com/curl/curl.git
_src := curl
_bin := $(_src)/src/curl
_branch := master
_depth := 1
_nproc ?= $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	make -C $(_src) clean


.PHONY: uninstall
uninstall:
	make -C $(_src) uninstall


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch),$(_depth))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call check_pkgs,libpsl-dev)
	$(call check_binary,autoreconf)
	cd $(_src) \
		&& autoreconf -fi \
		&& ./configure --with-openssl --prefix=$(PREFIX)
	make -C $(_src) -j $(_nproc)
	$(call log_info,compiling $@...)


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) install
