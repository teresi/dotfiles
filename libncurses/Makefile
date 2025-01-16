#!/usr/bin/make -f


# ncurses

# draws to terminal
# requires pkgconf


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/


_release_ver := 6.5
_release_tar := ncurses-$(_release_ver).tar.gz
_release_tar_url := https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz
_md5_sum := ac2d2629296f04c8537ca706b6977687

_src := ncurses
_bin := $(_src)/ncurses/libncurses.so.$(_release_ver)
_install := $(PREFIX)/lib/libncurses.so


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: download
download: $(_src)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; exit 1) \
		&& rm -rf $(_src) \
		&& tar -xf $(_release_tar) \
		&& mv $(_src)-$(_release_ver) $(_src)


$(_bin): | $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) && \
	./configure \
		--prefix=${PREFIX} \
		--with-shared \
		--with-termlib \
		--without-debug \
		--enable-pc-files \
		--with-versioned-syms \
		--with-pkg-config-libdir=${PREFIX}/lib/pkgconfig
	make -C $(_src) -j


$(_install): $(_bin)
	make -C $(_src) install
