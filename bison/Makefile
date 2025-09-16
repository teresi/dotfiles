#!/usr/bin/env make -S -f

# compile bison

# bison is a parser generator for GNU
# it is a translator used to generate other source files
# it is similar to Yet Another Compiler Compile (YACC)
#
# FUTURE reconcile these dependencies with what we already build
# autoconf automake autopoint flex gperf graphviz help2man texinfo valgrind gnupg


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
export PATH := $(PREFIX)/bin:$(PATH)

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_src := bison
_bin := $(_src)/src/bison
_install := $(PREFIX)/bin/bison

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
# MAGIC Akim Demaille's ID, see `gpg -d *sig`
_gpg_id  := 7DF84374B1EE1F9764BBE25D0DDCAA3278D5264E
_release_ver := 3.8.2
_release_tar := bison-$(_release_ver).tar.gz
_release_sig := bison-$(_release_ver).tar.gz.sig
_release_tar_url := https://ftp.gnu.org/gnu/bison/bison-$(_release_ver).tar.gz
_release_sig_url := https://ftp.gnu.org/gnu/bison/bison-$(_release_ver).tar.gz.sig


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


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
	$(call log_info,unpacking $@...)

    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		|| gpg --import $(_gpg_key)

	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid bison sig"; exit 1)

	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid bison tar"; exit 1) \
		&& (mkdir -p $(_src) && tar -xzvf $(_release_tar) -C $(_src)/ --strip-components=1)
	touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) && ./configure --prefix=$(PREFIX) && make -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	cd $(_src) && make install
