#!/usr/bin/env make -S -f

# libunistring

# libunistring.so

# unicode strings in C
#
# dependency for libpsl


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_src := libunistring
_lib := $(_src)/lib/.libs/libunistring.so
_install := $(PREFIX)/lib/libunistring.so

_tarball     := $(_src).tar.gz
_tarball_sig := $(_src).tar.gz.sig
_tarball_id  := $(_src).tar.gz.id
_gpg_id      := 9001B85AF9E1B83DF1BDA942F5BE8B267C6A406D


.PHONY: all
all: $(_lib)


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


$(_src): $(_tarball) $(_tarball_sig) $(_tarball_id)


$(_src)/Makefile.in: | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	$(call log_info,compiling $@...)
	cd $(_src) && ./configure --prefix=$(PREFIX)


$(_lib): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -C $(_src) -j
	make -C $(_src) -j check


$(_install): $(_lib)
	$(call log_info,installing $@...)
	make -C $(_src) -j install
