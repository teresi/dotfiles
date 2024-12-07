#!/usr/bin/make -f

# compile pkgconf

# tools for path handling during the configure step
# successor to pkg-config


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

_dir := $(_root_dir)/pkgconf
_bin := $(_dir)/pkgconf
_install := $(PREFIX)/bin/pkgconf

_release_ver := 2.1.1
_release_tar := pkgconf-$(_release_ver).tar.xz
_release_tar_url := https://distfiles.ariadne.space/pkgconf/pkgconf-2.1.1.tar.xz
_md5_sum := bc29d74c2483197deb9f1f3b414b7918


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_dir) clean
	rm $(_release_sig)
	rm $(_release_tar)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_dir) uninstall


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_dir):  $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; exit $?) \
		&& tar -xf $(_release_tar) \
		&& mv $(_dir)-$(_release_ver) $(_dir)


$(_bin): | $(_dir)
	cd $(_dir) \
		&& ./configure \
			--prefix=$(PREFIX) \
		&& make -j


$(_install): $(_bin)
	cd $(_dir) && make install
