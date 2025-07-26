#!/usr/bin/make -f

# fuzzy finder


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

_src := fzf
_url := https://github.com/junegunn/fzf.git
_bin := $(HOME)/.fzf.bash


.PHONY: all
all: $(_src)/.git


.PHONY: clean
clean:
	rm -rf *.zip


.PHONY: uninstall
uninstall:
	$(call log_info,uninstalling fzf...)
	rm -rf $(_src)


.PHONY: install
install: all $(_bin)


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


.PHONY: download
download: repo


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(_src)/install --all
