#!/usr/bin/env make -S -f

# compile rust-analyzer
#
# language server for Rust

# BINARIES PROVIDED
# rust-analyzer


include ../helpers.mk
PREFIX ?= $(HOME)/.cargo/
SHELL ?= /bin/bash


_url := https://github.com/rust-lang/rust-analyzer.git
_branch := master
_src := rust-analyzer
_install := $(PREFIX)/bin/rust-analyzer


.PHONY: all
all: git-hash


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_install): git-hash
	$(call log_info,updating $@...)
	cd $(_src) && cargo xtask install --server
