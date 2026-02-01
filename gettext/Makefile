#!/usr/bin/env make -S -f

# compile gettext

# gettext provides tools for internationalization and localization

# BINARIES
# autopoint, envsubst, gettext, gettext.sh, gettextize, msgattrib, msgcat, msgcmp, msgcomm, msgconv, msgen, msgexec, msgfilter, msgfmt, msggrep, msginit, msgmerge, msgunfmt, msguniq, ngettext, recode-sr-latin, xgettext

# LIBRARIES
# libasprintf.so, libgettextlib.so, libgettextpo.so, libgettextsrc.so, libtextstyle.so, and preloadable_libintl.so


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_src := gettext
_bin := $(_src)/gettext-runtime/src/gettext
_install := $(PREFIX)/bin/gettext

_tarball     := $(_src).tar.gz
_tarball_sig := $(_src).tar.gz.sig
_tarball_id  := $(_src).tar.gz.id
_gpg_id      := E0FFBD975397F77A32AB76ECB6301D9E1BBEAC08


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


$(_src): $(_tarball) $(_tarball_sig) $(_tarball_id)


$(_src)/Makefile.in: | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) && ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	$(call log_warn,compiling $@ this may take a few minutes... this is ok...)
	sleep 1
	make -j -C $(_src) all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -j -C $(_src) install
