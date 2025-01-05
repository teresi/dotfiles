#!/usr/bin/make -f

# compile neovim

# NEOVIM is an editor and successor to vim


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_install := $(PREFIX)/bin/nvim

_url := https://github.com/neovim/neovim.git

_src := neovim
_build := build
_bin := $(_src)/$(_build)/bin/nvim

_branch := master
_depth :=
_nproc ?= $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(MAKE) -C $(_src) clean
	$(MAKE) -C $(_src) distclean


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch),$(_depth))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call check_pkgs,build-essential)
	$(call check_binary,ninja gettext cmake unzip curl)
	make -C $(_src) \
		-j $(_nproc) \
		CMAKE_BUILD_TYPE=Release \
		CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$(PREFIX)"


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) \
		-j $(_nproc) \
		install
