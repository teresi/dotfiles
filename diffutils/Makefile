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

_src := diffutils
_bin := $(_src)/src/diff
_install := $(PREFIX)/bin/diff

# downloaded tarball here given the url stored in %.tar.gz.url
_tarball     := $(_src).tar.gz
# download sig here given the url stored in %.tar.gz.sig.url
_tarball_sig := $(_src).tar.gz.sig
# empty target for whether we pulled the key
_tarball_id  := $(_src).tar.gz.id
# MAGIC Jim Meyering's ID, see `gpg -d *sig`
_gpg_id  := 155D3FC500C834486D1EEA677FD9FCCB000BEEEE


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


$(_src): $(_tarball) $(_tarball_sig) $(_tarball_id)


$(_src)/Makefile.in: | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) && ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -j -C $(_src) all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
