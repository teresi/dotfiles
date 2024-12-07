#!/usr/bin/make -f

# compile screen

# terminal multiplexer

# requires libpam-dev


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

_dir := screen
_bin := $(_dir)/screen
_install := $(PREFIX)/bin/screen

_release_ver := 5.0.0
_release_tar := screen-$(_release_ver).tar.gz
_release_tar_url := https://ftp.gnu.org/gnu/screen/screen-5.0.0.tar.gz
_md5_sum := befc115989242ed4bceeff8d8bfeb4e6


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_dir) clean
	rm $(_release_sig)


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
			--infodir=$(PREFIX)/share/info \
			--mandir=$(PREFIX)/share/man \
			--enable-pam \
			--enable-telnet \
		&& make -j


$(_install): $(_bin)
	@# not installing based on recommendations from the authors
	@# keeping this code here for reference purposes
	$(error not installing, it is recommended to install screen as root, see screen/INSTALL)
	cd $(_dir) && make install
