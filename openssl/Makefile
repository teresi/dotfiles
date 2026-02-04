#!/usr/bin/env make -S -f

# compile openssl

# TLS, DTLS, SSL, binaries and libs

# BINARIES
# openssl

# LIBRARIES
# libcrypto libssl

# REQUIRES
# make perl zstd

# TODO: ensure perl modules are installed https://github.com/openssl/openssl/blob/master/NOTES-PERL.md


include ../helpers.mk
PREFIX ?= $(HOME)/.local/
SHELL ?= /bin/bash


_url := https://github.com/openssl/openssl.git
_branch := master
_src := openssl
_bin := $(_src)/apps/openssl
_install := $(PREFIX)/bin/openssl


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_src)/Makefile: git-hash
	cd $(_src) && ./Configure --prefix=$(PREFIX)
	touch $@


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	@# one less core so as to not lock the machine while compiling
	make -C $(_src) all \
		-j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))
	make -C $(_src) test \
		-j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) PREFIX=$(PREFIX) -j install
