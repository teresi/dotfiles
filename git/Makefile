#!/usr/bin/env make -S -f

# compile Git

# see https://github.com/git/git/blob/master/INSTALL
# see https://www.kernel.org/pub/software/scm/git/
# see https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
# see https://www.kernel.org/signature.html


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_url := $ https://git.kernel.org/pub/scm/git/git.git
_branch := v2.53.0
_src := git
_bin := $(_src)/git
_install := $(PREFIX)/bin/git


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


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_src)/configure: git-hash
	cd $(_src) \
		&& make configure


$(_bin): $(_src)/configure
	@# TODO: double check depencies and install, these should now be compiled but need to check and add to prereq
	@#$(call check_pkgs, dh-autoreconf libcurl4-gnutls-dev libexpat1-dev zlib1g-dev libssl-dev)
	@# TODO: exit if libcurl is not installed? https is necessary
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX) \
		&& make -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# NOTE profile-fast-install fails, try again in the future?
	make -C $(_src) PREFIX=$(PREFIX) install
