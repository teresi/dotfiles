#!/usr/bin/env make -S -f

# compile vim


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/vim/vim.git
_branch ?= master

_src := vim
_bin := $(_src)/src/vim
_install := $(PREFIX)/bin/vim


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then ninja -C $(_src)/$(_build) clean; fi


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call check_pkgs,git make clang libxt-dev)
	$(call check_binary,libtool)
	# FUTURE check these settings
	cd $(_src) \
		&& ./configure \
			--with-features=huge \
			--enable-multibyte \
			--enable-python3interp=yes \
			--enable-luainterp=yes \
			--enable-cscope \
			--prefix=$(PREFIX)
	make -C $(_src) -j


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) install
