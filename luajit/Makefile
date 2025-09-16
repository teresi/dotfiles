#!/usr/bin/env make -S -f

# compile LuaJIT

# just in time compiler for Lua


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

# using a mirror b/c the main site sometimes gets blocked
#_url := https://luajit.org/git/luajit.git
_url := https://github.com/LuaJIT/LuaJIT.git
_src := LuaJIT
_bin := $(_src)/src/luajit
_install := $(PREFIX)/bin/luajit

_branch := master


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then make -C $(_src) clean; fi


.PHONY: uninstall
uninstall:


.PHONY: download
download: repo


.PHONY: repo
repo:
	@# luajit doesn't appear to support shallow copies,
	@# so don't use the depth option
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call log_info,please wait...)
	make -C $(_src) PREFIX=$(PREFIX) all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) PREFIX=$(PREFIX) install
