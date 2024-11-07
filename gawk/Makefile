#!/usr/bin/make -f

# compile Gnu Awk

# text processor


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

_dir := $(_root_dir)/gawk
_bin := $(_dir)/gawk
_install := $(PREFIX)/bin/gawk

_release_ver := 5.3.1
_release_tar := gawk-$(_release_ver).tar.xz
_release_tar_url := https://ftp.gnu.org/gnu/gawk/gawk-5.3.1.tar.xz
_md5_sum := 4e9292a06b43694500e0620851762eec


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
