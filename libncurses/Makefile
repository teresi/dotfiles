#!/usr/bin/make -f


# ncurses

# draws to terminal
# requires pkgconf

SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

_release_ver := 6.5
_release_tar := ncurses-$(_release_ver).tar.gz
_release_tar_url := https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz
_md5_sum := ac2d2629296f04c8537ca706b6977687

_dir := $(_root_dir)/ncurses
_bin := $(_dir)/ncurses/libncurses.so.$(_release_ver)
_install := $(PREFIX)/lib/libncurses.so


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_dir) clean
	rm -rf $(_dir)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_dir) uninstall


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_dir):  $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; exit 1) \
		&& rm -rf $(_dir) \
		&& tar -xf $(_release_tar) \
		&& mv $(_dir)-$(_release_ver) $(_dir)


$(_bin): | $(_dir)
	cd $(_dir) && \
	./configure \
		--prefix=${PREFIX} \
		--with-shared \
		--with-termlib \
		--without-debug \
		--enable-pc-files \
		--with-versioned-syms \
		--with-pkg-config-libdir=${PREFIX}/lib/pkgconfig
	make -C $(_dir) -j


$(_install): $(_bin)
	make -C $(_dir) install
