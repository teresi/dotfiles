#!/usr/bin/make -f

# compile LuaJIT

# just in time compiler for Lua


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_url := https://luajit.org/git/luajit.git
_src := luajit
_bin := $(_src)/src/luajit
_install := $(PREFIX)/bin/luajit

_branch := master
_depth :=


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
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch),$(_depth))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call log_info,please wait...)
	make -C $(_src) PREFIX=$(PREFIX) all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) PREFIX=$(PREFIX) install
