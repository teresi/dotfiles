#!/usr/bin/env make -S -f

# libidn2

# idn2			# binary
# libidn2.so	# lib

# internationalized string handling
#
# dependency for curl


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_src := libidn2
_bin := $(_src)/src/idn2
_install := $(PREFIX)/bin/idn2

_tarball     := $(_src).tar.gz
_tarball_sig := $(_src).tar.gz.sig
_tarball_id  := $(_src).tar.gz.id
# MAGIC ID for the signature, see `gpg -d *sig`
_gpg_id      := B1D2BD1375BECB784CF4F8C4D73CF638C53C06BE



.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	@# not removing the tarball etc here so it builds without having to download
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi
	@# remove the makefile so configure runs
	rm -f $(_src)/Makefile


.PHONY: download
download: $(_src)


$(_tarball_id):
	@# empty target signifying that the key has been pulled
	gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		&& echo $(_gpg_id) > $@


$(_src): $(_tarball) $(_tarball_sig) $(_tarball_id)


$(_src)/Makefile.in: | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) && ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -C $(_src) -j
	make -C $(_src) -j check


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) -j install
