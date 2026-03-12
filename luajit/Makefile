#!/usr/bin/env make -S -f

# compile LuaJIT

# just in time compiler for Lua
#
# prerequisite for neovim


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

# using a mirror b/c the main site sometimes gets blocked
#_url := https://luajit.org/git/luajit.git
_url := https://github.com/LuaJIT/LuaJIT.git
_branch := v2.1
_src := LuaJIT
_bin := $(_src)/src/luajit
_install := $(PREFIX)/bin/luajit


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi

.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then make -C $(_src) clean; fi


.PHONY: download
download: repo


.PHONY: repo
repo:
	@# luajit doesn't appear to support shallow copies,
	@# so don't use the depth option
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_bin): git-hash
	$(call log_info,compiling $@...)
	make -C $(_src) PREFIX=$(PREFIX) all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) PREFIX=$(PREFIX) install
