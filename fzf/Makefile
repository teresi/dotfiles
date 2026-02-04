#!/usr/bin/env make -S -f

# fuzzy finder


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local


_url := https://github.com/junegunn/fzf.git
_branch := master
_src := fzf
_install := $(HOME)/.fzf.bash


.PHONY: all
all: git-hash


.PHONY: clean
clean:


.PHONY: uninstall
uninstall:
	$(call log_info,uninstalling fzf...)
	$(_src)/uninstall


.PHONY: install
install: $(_install)


$(_install): git-hash
	$(_src)/install --all


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))
