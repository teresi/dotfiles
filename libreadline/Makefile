#!/usr/bin/env make -S -f

# compile readline

# libhistory.so
# libreadline.so

# readline is likely installed as a dependency of bash
#
# SEE https://tiswww.case.edu/php/chet/readline/rltop.html
# The GNU Readline library provides a set of functions for use by
# applications that allow users to edit command lines as they are typed in.
#
# requires M4 (1.4.16 +)
# requires Perl (5.006 +)


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# ubuntu 22 shipped w/ 8.1.2
_release_ver := 8.3

_src := readline
_bin := $(_src)/libreadline.a
_install := $(PREFIX)/lib/libreadline.a

_tarball     := $(_src).tar.gz
_tarball_sig := $(_src).tar.gz.sig
_tarball_id  := $(_src).tar.gz.id
_gpg_id      := 7C0135FB088AAF6C66C650B9BB5869F064EA74AB


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi
	if [ -f "$(_src)/Makefile.in" ]; then touch $(_src)/Makefile.in; fi


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) uninstall; fi


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
	@# SHLIB_LIBS="-lncursesw" forces it to link against ncurses
	cd $(_src) \
		&&  LDFLAGS=-L$(PREFIX)/lib \
		    CFLAGS=-I$(PREFIX)/include \
		    PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig:"$$PKG_CONFIG_PATH" \
			./configure \
				--prefix=$(PREFIX) \
				--with-curses


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -C $(_src) SHLIB_LIBS="-lncursesw" -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
