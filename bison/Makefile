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

# downloaded tarball here given the url stored in %.tar.gz.url
_tarball     := $(_src).tar.gz
# download sig here given the url stored in %.tar.gz.sig.url
_tarball_sig := $(_src).tar.gz.sig
# empty target for whether we pulled the key
_tarball_id  := $(_src).tar.gz.id
# MAGIC ID for the signature, see `gpg -d *sig`
_gpg_id      := 7DF84374B1EE1F9764BBE25D0DDCAA3278D5264E


.SECONDARY: $(tarball_sig)


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
	$(MAKE) -C $(_src) uninstall


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
