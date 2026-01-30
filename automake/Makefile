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

# downloaded tarball here given the url stored in %.tar.gz.url
_tarball     := $(_src).tar.gz
# download sig here given the url stored in %.tar.gz.sig.url
_tarball_sig := $(_src).tar.gz.sig
# empty target for whether we pulled the key
_tarball_id  := $(_src).tar.gz.id
# MAGIC ID for the signature, see `gpg -d *sig`
_gpg_id      := 17D3311B14BC0F248267BF020716748A30D155AD


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


$(_tarball_id):
	@# empty target signifying that the key has been pulled
	gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		&& echo $(_gpg_id) > $@


$(_src): $(_targball) $(_targball_sig) $(_targball_id)


$(_src)/Makefile.in: | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) && ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -j -C $(_src) all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
