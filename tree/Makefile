#!/usr/bin/env make -S -f

# compile tree

# displays contents of a directory

# NOTE: using git to download this b/c the tar uses bz2,
# and that requires a lot of dependencies


include ../helpers.mk
PREFIX ?= $(HOME)/.local/
SHELL ?= /bin/bash


_url := https://github.com/Old-Man-Programmer/tree.git
_branch := 2.3.2
_src := unix-tree
_bin := $(_src)/tree
_install := $(PREFIX)/bin/tree


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	rm -f $(_install)


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_bin): $(_src)/Makefile git-hash
	$(call log_info,updating $@...)
	make -C $(_src) -j


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -C $(_src) PREFIX=$(PREFIX) MANDIR=$(PREFIX)/share/man install
