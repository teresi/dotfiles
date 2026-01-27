#!/usr/bin/env make -S -f

# compile EXAMPLE

# EXAMPLE
# is a snippet for compiling a source from a tar.gz
# downloads, verifies, and unpacks a tarball to $(_src)
# compiles the project assuming the basics: configure/make/make install
#
# BINARIES
# ...
#
# LIBRARIES
# ...
#
# REQUIRES
# ...
#
# TODO
# [ ] update Makefile variables: _src, _bin, _install, _gpg_id
# [ ] update .gitignore to ignore the source folder
# [ ] update the files EXAMPLE.tar.gz.url, EXAMPLE.tar.gz.sig.url
# 		[ ] update the filename prefixes to match the $(_src) variable
# 		[ ] update the URLs in the files point to tarbal and signature files to download
# [ ] update the rules to compile the project depending on it's compilation
# [ ] update the docs


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/


# source directory destination
_src := EXAMPLE
# binary (or lib) compiled
_bin := $(_src)/bin/EXAMPLE
# destination for the bin (or lib) when installed
_install := $(PREFIX)/bin/EXAMPLE


# downloaded tarball here given the url stored in %.tar.gz.url
_tarball     := $(_src).tar.gz
# download sig here given the url stored in %.tar.gz.sig.url
_tarball_sig := $(_src).tar.gz.sig
# empty target for whether we pulled the key
_tarball_id  := $(_src).tar.gz.id
# MAGIC ID for the signature, see `gpg -d *sig`
_gpg_id      := 82F854F3CE73174B8B63174091FCC32B6769AA64


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
