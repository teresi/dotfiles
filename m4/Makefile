#!/usr/bin/make -f

# compile M4

# M4 is a unix macro processor
#
# prerequisite of autoconf


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
_dir := $(_root_dir)/m4
_bin := $(_dir)/src/m4
_install := $(PREFIX)/bin/m4
_depends := gawk

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
_release_ver := 1.4.19
_release_tar := m4-$(_release_ver).tar.gz
_release_sig := $(_release_tar).sig
_release_tar_url := https://mirrors.ibiblio.org/gnu/m4/m4-$(_release_ver).tar.gz
_release_sig_url := $(_release_tar_url).sig


.PHONY: all
all: check $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_dir) clean
	rm $(_release_sig)
	rm $(_release_tar)


.PHONY: check
check:
	@$(foreach prog,$(_depends),type -t $(prog) 2>&1 >/dev/null || (echo "depedency not in PATH: $(prog)"; exit 1);)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_dir) uninstall


$(_gpg_key):
	curl -C - -o $(_gpg_key) $(_gpg_url)


$(_release_sig):
	curl -C - -o $(_release_sig) $(_release_sig_url)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_dir):  $(_release_sig) $(_release_tar) $(_gpg_key)
	gpg --verify $(_root_dir)/$(_release_sig) 2>&1 \
		| grep 'RSA' | awk '{print $$5}' \
		| xargs -I {} gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys {}
	gpg --verify --keyring $(_root_dir)/$(_gpg_key) $(_root_dir)/$(_release_sig) \
		|| (echo "invalid M4 sig"; exit 1)
	gpg --verify $(_root_dir)/$(_release_sig) $(_root_dir)/$(_release_tar) \
		|| (echo "invalid M4 tar"; exit 1) \
		&& (mkdir -p $(_dir) && tar -xzvf $(_release_tar) -C $(_dir)/ --strip-components=1)


$(_bin): | $(_dir)
	cd $(_dir) && ./configure --prefix=$(PREFIX) && make -j
	@#not calling make check b/c 1.4.19 has a bug, fixed in 1.4.20? see https://bugs.gentoo.org/808749


$(_install): $(_bin)
	cd $(_dir) && make install
