#!/usr/bin/make -f

# compile GNU Make

# Make generates executables and other files provided other files


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
export PATH := $(PREFIX)/bin:$(PATH)

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_src := make
_bin := $(_src)/make
_install := $(PREFIX)/bin/make

_gpg_key := gnu-keyring.gpg
_gpg_uri := https://ftp.gnu.org/gnu/gnu-keyring.gpg

_ver := 4.4.1

_tar := make-$(_ver).tar.gz
_tar_uri := https://ftp.gnu.org/gnu/make/make-$(_ver).tar.gz

_sig := make-$(_ver).tar.gz.sig
_sig_uri := https://ftp.gnu.org/gnu/make/make-$(_ver).tar.gz.sig


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
	$(call log_info,downloading key $@...)
	curl -C - -o $(_gpg_key) $(_gpg_uri)


$(_sig):
	$(call log_info,downloading signature $@...)
	curl -C - -o $(_sig) $(_sig_uri)


$(_tar):
	$(call log_info,downloading tarball $@...)
	curl -C - -o $(_tar) $(_tar_uri)


$(_src):  $(_sig) $(_tar) $(_gpg_key)

	gpg --verify $(_root_dir)/$(_release_sig) 2>&1 \
		| grep 'RSA' | awk '{print $$5}' \
		| xargs -I {} gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys {}

	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_sig) \
		|| (echo "invalid sig"; exit 1)

	$(call log_info,extracting source directory $@...)
	gpg --verify $(_root_dir)/$(_sig) $(_root_dir)/$(_tar) \
		|| (echo "invalid tar"; exit 1) \
		&& (mkdir -p $(_src) && tar -xzvf $(_tar) -C $(_src)/ --strip-components=1)
	touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) && ./configure --prefix=$(PREFIX) && make -j
	$(call log_info,compiling $@... DONE)


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
	$(call log_info,installing $@... DONE)
