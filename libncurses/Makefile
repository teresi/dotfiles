#!/usr/bin/env make -S -f


# ncurses

# draws to terminal
# requires pkgconf


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/


_src := ncurses
_bin := $(_src)/lib/libncursesw.so.6.6
_install := $(PREFIX)/lib/libncursesw.so.6.6

_tarball     := $(_src).tar.gz
_tarball_sig := $(_src).tar.gz.sig
_tarball_id  := $(_src).tar.gz.id
_gpg_id      := 19882D92DDA4C400C22C0D56CC2AF4472167BE03

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
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) uninstall; fi


$(_tarball_id):
	@# empty target signifying that the key has been pulled
	gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		&& echo $(_gpg_id) > $@


$(_src): $(_tarball) $(_tarball_sig) $(_tarball_id)


$(_src)/Makefile.in: | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	@# --disable-widec:  ncurses
	@# --enable-widec:   ncursesw
	@# --with-termlib:   build tinfo.so seperately
	cd $(_src) && \
	./configure \
		--prefix=${PREFIX} \
		--with-shared \
		--without-debug \
		--enable-pc-files \
		--with-versioned-syms \
		--with-pkg-config-libdir=${PREFIX}/lib/pkgconfig


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -j -C $(_src)


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -j -C $(_src) install
