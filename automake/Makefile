#!/usr/bin/env make -S -f

# compile automake

# tools for generating Makefiles for use w/ autoconf
#
# provides `automake` and `aclocal`
# provides
# aclocal:   generate aclocal.m4 from configure.in
# automake:  generate Makefile.in from Makefile.am


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
export PATH := $(PREFIX)/bin:$(PATH)

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_src := automake
_bin := $(_src)/bin/automake
_install := $(PREFIX)/bin/automake

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
_release_ver := 1.16.5
_release_tar := automake-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig
_release_tar_url := https://mirrors.ocf.berkeley.edu/gnu/automake/$(_release_tar)
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


$(_gpg_key):
	curl -C - -o $(_gpg_key) $(_gpg_url)


$(_release_sig):
	curl -C - -o $(_release_sig) $(_release_sig_url)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_sig) $(_release_tar) $(_gpg_key)
	gpg --verify $(_root_dir)/$(_release_sig) 2>&1 \
		| grep 'RSA' | awk '{print $$5}' \
		| xargs -I {} gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys {}
	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid signature $(_release_sig)"; exit 1)
	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid tar $(_release_tar)"; exit 1) \
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
