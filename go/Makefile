#!/usr/bin/env make -S -f

include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_src := go
_bin := $(_src)/bin/go
_install := $(PREFIX)/bin/go

_release_tar := go1.26.1.linux-amd64.tar.gz
_release = $(basename $(basename $(_release_tar)))
_release_tar_url := https://go.dev/dl/go1.26.1.linux-amd64.tar.gz
_release_sig := 031f088e5d955bab8657ede27ad4e3bc5b7c1ba281f05f245bcc304f327c987a


.PHONY: all
all: $(_release_tar)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	rm -rf $(_install)


.PHONY: download
download: $(_release_tar)


$(_release_tar):
	@# using wget, downloading with curl resulted in bad checksums
	wget -c $(_release_tar_url)
	echo "$(_release_sig) $(_release_tar)" | sha256sum --check --status \
		|| (echo "checksum failed: $(_release_tar)"; rm $(_release_tar); exit 1)


$(_src):  $(_release_tar)
	@# the go tarball unpacks to `go` by default
	echo "$(_release_sig) $(_release_tar)" | sha256sum --check --status \
		|| (echo "checksum failed: $(_release_tar)"; exit 1) \
		&& rm -rf $(_src) \
		&& tar -xzf $(_release_tar)


$(_bin): $(_src)
	$(call log_info,unpacking $@...)


$(_install): $(_release_tar)
	$(call log_info,installing $@...)
	rm -f $(_install)
	ln -s $(realpath $(_bin)) $(_install)
	touch $(_install)
