#!/usr/bin/env make -S -f

# compile rust-analyzer
#
# language server for Rust

# BINARIES PROVIDED
# rust-analyzer


include ../helpers.mk
PREFIX ?= $(HOME)/.cargo/
SHELL ?= /bin/bash

# NB: using release as previous compilations were stuck in debug mode, which is much slower
_release_tar_url := https://github.com/rust-lang/rust-analyzer/releases/download/2026-09-21/rust-analyzer-x86_64-unknown-linux-gnu.gz
_release_tar := $(notdir $(_release_tar_url))
_release = $(basename $(_release_tar))
_release_sig := b2d24ce2bda2ea05b1ad7c2917d205f8111775f703ccd908e6061803ae8257d0

_install := $(PREFIX)/bin/rust-analyzer
_bin := rust-analyzer


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	rm -f $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	rm -f $(_release_tar)
	rm -f $(_bin)


.PHONY: download
download: $(_release_tar)


$(_release_tar):
	$(call log_info,updating $@...)
	@# using wget, downloading with curl resulted in bad checksums
	wget -c $(_release_tar_url)
	echo "$(_release_sig) $(_release_tar)" | sha256sum --check --status \
		|| (echo "checksum failed: $(_release_tar)"; rm $(_release_tar); exit 1)


$(_bin): $(_release_tar)
	$(call log_info,updating $@...)
	gunzip -c $(_release_tar) > $@ \
	&& chmod +x $@


$(_install): $(_bin)
	$(call log_info,updating $@...)
	cp $^ $@ \
	&& chmod +x $@
