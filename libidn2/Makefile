#!/usr/bin/make -f

# libidn2

# idn2			# binary
# libidn2.so	# lib

# internationalized string handling
#
# dependency for curl


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_src := libidn2
_bin := $(_src)/src/idn2
_install := $(PREFIX)/bin/idn2

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
_release_ver := 2.3.8
_release_tar := libidn2-$(_release_ver).tar.gz
_release_sig := libidn2-$(_release_ver).tar.gz.sig
_release_tar_url := https://ftp.gnu.org/gnu/libidn/libidn2-$(_release_ver).tar.gz
_release_sig_url := https://ftp.gnu.org/gnu/libidn/libidn2-$(_release_ver).tar.gz.sig


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	$(MAKE) -ik -C $(_src) clean


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


$(_src): $(_release_sig) $(_release_tar) $(_gpg_key)
	$(call log_info,unpacking $@...)
	gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		|| gpg --import $(_gpg_key)
	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid libidn2 sig"; exit 1)
	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid libidn2 tar"; exit 1) \
		&& (mkdir -p $(_src) && tar -xzvf $(_release_tar) -C $(_src)/ --strip-components=1)
	touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) && ./configure --prefix=$(PREFIX)
	make -C $(_src) -j
	make -C $(_src) -j check


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) -j install
