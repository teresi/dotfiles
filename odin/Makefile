#!/usr/bin/env make -S -f

# compile ODIN lang

# Odin is a compiled C-like language


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_install := $(PREFIX)/bin/odin

_url := https://github.com/odin-lang/Odin

_src := Odin
_bin := $(_src)/odin

_branch := dev-2024-12


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_warn,nothing to clean for ODIN lang!)


.PHONY: uninstall
uninstall:
	rm -f $(_install)


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call check_binary,llvm-config)
	$(call check_binary,clang)
	cd $(_src) \
		&& make release-native


$(_install): $(_bin)
	$(call log_info,updating $@...)
	cp $(_src)/odin $(_install)
