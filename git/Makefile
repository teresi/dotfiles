#!/usr/bin/make -f

# compile Git

# see https://github.com/git/git/blob/master/INSTALL
# see https://www.kernel.org/pub/software/scm/git/
# see https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
# see https://www.kernel.org/signature.html


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_url := $ https://git.kernel.org/pub/scm/git/git.git
_branch := v2.48.1
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


.PHONY: uninstall
uninstall:


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


.PHONY: download
download: repo


$(_src)/.git: | repo


$(_bin): | $(_src)
	$(call check_binary, gettext)
	@# NOTE xz-utils is nedded if downloading tar.xz
	$(call check_pkgs, dh-autoreconf libcurl4-gnutls-dev libexpat1-dev zlib1g-dev libssl-dev)
	cd $(_src) \
		&& make configure \
		&& ./configure --prefix=$(PREFIX) \
		&& make -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# NOTE profile-fast-install fails, try again in the future?
	make -C $(_src) PREFIX=$(PREFIX) install
