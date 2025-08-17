#!/usr/bin/make -f

# compile readline

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

_release_ver := 8.2

_src := readline
_bin := $(_src)/libreadline.a
_install := $(PREFIX)/lib/libreadline.a

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
# MAGIC Chet Ramey's ID, see `gpg -d *sig`
_gpg_id  := 7C0135FB088AAF6C66C650B9BB5869F064EA74AB

_release_tar := readline-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig

_release_tar_url := https://ftp.gnu.org/gnu/readline/readline-$(_release_ver).tar.gz
_release_sig_url := $(_release_tar_url).sig


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


$(_gpg_key):
	curl -C - -o $(_gpg_key) $(_gpg_url)


$(_release_sig):
	curl -C - -o $(_release_sig) $(_release_sig_url)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_sig) $(_release_tar) $(_gpg_key)

	gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		|| gpg --import $(_gpg_key)

	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid signature"; exit 1)

	$(call log_info,extracting source directory $@...)
	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid tar"; exit 1) \
		&& (mkdir -p $(_src) && tar -xzvf $(_release_tar) -C $(_src)/ --strip-components=1)
	touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX) \
		&& make SHLIB_LIBS=-lcurses -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
