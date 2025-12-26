#!/usr/bin/env make -S -f

# compile autoconf

# autoconf is a tool that automatically configures source code
# it aims to provide a "reliable discovery of system-specific build and runtime information"
#
# see https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/autoconf.html
#
# for example, it checks your system for dependencies and generates Makefiles
# this is a common step used prior to calling `make` on gnu sources
#
# requires M4 (1.4.16 +)
# requires Perl (5.006 +)


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_src := autoconf
_bin := $(_src)/bin/autoconf
_install := $(PREFIX)/bin/autoconf

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
_release_ver := 2.72
_release_tar := autoconf-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig
_release_tar_url := https://ftp.gnu.org/gnu/autoconf/autoconf-$(_release_ver).tar.gz
_release_sig_url := $(_release_tar_url).sig


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi
	rm -f $(_src)/Makefile


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: download
download: $(_src)


# FUTURE: should only need to download this once

$(_gpg_key):
	curl -C - -o $(_gpg_key) $(_gpg_url)


# FUTURE: get target from url via
# @echo "Basename (without suffix/directory): $(basename $(notdir $(_release_sig_url)))"

$(_release_sig):
	curl -C - -o $(_release_sig) $(_release_sig_url)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_sig) $(_release_tar) $(_gpg_key)
	gpg --verify $(_root_dir)/$(_release_sig) 2>&1 \
		| grep 'RSA' | awk '{print $$5}' \
		| xargs -I {} gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys {}
	# BUG: checking the tar file twice here? the first checks the tar, not the sig
	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid autoconf sig"; exit 1)
	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid autoconf tar"; exit 1) \
		&& (mkdir -p $(_src) && tar -xzvf $(_release_tar) -C $(_src)/ --strip-components=1)
	touch $(_src)


$(_src)/Makefile.in: | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) && ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -j -C $(_src) all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
