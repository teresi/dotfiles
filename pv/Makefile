#!/usr/bin/make -f

# Pipe Viewer
# command line tool to visualize data through a pipe


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_install := $(PREFIX)/bin/pv

_url := https://github.com/icetee/pv.git
_src := pv
_bin := $(_src)/pv

_branch ?= master


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	-$(MAKE) clean -C $(_src)


.PHONY: uninstall
uninstall:
	$(MAKE) uninstall -C $(_src)


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	cd $(_src) \
		&& ./configure --prefix=$(HOME)/.local \
		&& make -j


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) install -C $(_src)
