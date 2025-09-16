#!/usr/bin/env make -S -f

# compile bzip2

# file compression tool
# https://www.sourceware.org/bzip2/downloads.html

include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local

_url := $ https://gitlab.com/bzip2/bzip2
_branch := master
_src := bzip2
_build := $(_src)/build
_bin := $(_build)/bzip2
_install := $(PREFIX)/bin/bzip2
_manifest := $(_build)/install_manifest.txt


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_build)" ]; then make -C $(_build) clean; fi


.PHONY: uninstall
uninstall:
	if [ -f "$(_manifest)" ]; then xargs rm -f < $(_manifest); fi


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


.PHONY: download
download: repo


$(_build):
	mkdir -p $(_build)


$(_src)/.git: | repo


$(_bin): $(_src)/.git | $(_build)
	$(call log_info,updating $@...)

	@# need: pkg-config, cmake
	@# FUTURE ENABLE_LIB_ONLY can be used to only build libbz2
	cd $(_build) \
		&& cmake .. \
			-DCMAKE_BUILD_TYPE="Release" \
			-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
		&& cmake --build . \
		&& ctest -V


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# meson is available but you need `pytest` installed for the tests
	@# so I've opted for cmake here b/c we don't have to setup pip/pytest
	@# touch the target, or else it will always rebuild
	cd $(_build) \
		&& cmake --build . --target install \
		&& if [ -f "$(_install)" ]; then touch $(_install); fi
