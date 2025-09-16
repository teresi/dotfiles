#!/usr/bin/env make -S -f

# compile Lua

# Lua is a lightweight scripting language


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_src := lua
_bin := $(_src)/src/lua
_install := $(PREFIX)/bin/lua

# using 5.1 for neovim packages
_release_ver := 5.1.5
_release_tar := lua-$(_release_ver).tar.gz
_release_tar_url := https://www.lua.org/ftp/lua-$(_release_ver).tar.gz
_release_sig := 2640fc56a795f29d28ef15e13c34a47e223960b0240e8cb0a82d9b0738695333


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
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: download
download: $(_src)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_tar)
	echo "$(_release_sig) $(_release_tar)" | sha256sum --check --status \
		|| (echo "checksum failed: $(_release_tar)"; exit 1) \
		&& rm -rf $(_src) \
		&& tar -xf $(_release_tar) \
		&& mv $(_src)-$(_release_ver) $(_src) \
		&& touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	$(call check_pkgs, build-essential libreadline-dev)
	make -C $(_src) INSTALL_TOP=$(PREFIX) linux test


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) INSTALL_TOP=$(PREFIX) install
