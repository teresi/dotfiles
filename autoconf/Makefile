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

_release_tar := autoconf-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig
_release_tar_url := https://ftp.gnu.org/gnu/autoconf/autoconf-$(_release_ver).tar.gz
_release_sig_url := $(_release_tar_url).sig


# downloaded tarball here given the url stored in %.tar.gz.url
_tarball     := autoconf.tar.gz
# download sig here given the url stored in %.tar.gz.sig.url
_tarball_sig := autoconf.tar.gz.sig
# MAGIC ID for the signature, see `gpg -d *sig`
_gpg_id      := 82F854F3CE73174B8B63174091FCC32B6769AA64
# empty target for whether we pulled the key
_tarball_id  := autoconf.tar.gz.id


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	@# not removing the tarball etc here so it builds without having to download
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi
	@# remove the makefile so configure runs
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
