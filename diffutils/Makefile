#!/usr/bin/env make -S -f

# compile diffutils
#
# diff, diff3, sdiff, cmp

# shows the differences between files or directories
# see https://www.gnu.org/software/diffutils/

# NB diffutils are installed in the base image for Ubuntu (typically)
#    however they are *not* in the redhat/ubi8 image

# if reocnfiguring, requires
# autoconf, automake, gettext, help2man, texinfo


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_src := diffutils
_bin := $(_src)/src/diff
_install := $(PREFIX)/bin/diff

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
# MAGIC Jim Meyering's ID, see `gpg -d *sig`
_gpg_id  := 155D3FC500C834486D1EEA677FD9FCCB000BEEEE

_release_ver := 3.12
_release_tar := diffutils-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig
_release_tar_url := https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.gz
_release_sig_url := $(_release_tar_url).sig


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

	gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		|| gpg --import $(_gpg_key)

	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid signature"; exit 1)

	$(call log_info,extracting source directory $@...)
	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid tar"; exit 1) \
		&& (mkdir -p $(_src) && tar -xzvf $(_release_tar) -C $(_src)/ --strip-components=1)

	touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX) \
		&& make -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
