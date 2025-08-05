#!/usr/bin/make -f

# compile Universal CTAGS


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_url := https://github.com/universal-ctags/ctags.git
_branch := master
_src := ctags
_bin := $(_src)/ctags
_install := $(PREFIX)/bin/ctags


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then make -C $(_src) clean; fi
	@# BUG need a proper uninstall target


.PHONY: uninstall
uninstall:
	make -C $(_src) PREFIX=$(PREFIX) uninstall


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


.PHONY: download
download: repo


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	cd $(_src) \
		&& ./autogen.sh \
		&& ./configure --prefix=$(PREFIX) \
		&& make -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# NOTE profile-fast-install fails, try again in the future?
	make -C $(_src) PREFIX=$(PREFIX) install
