#!/usr/bin/env make -S -f

# compile unzip

# zip extraction


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/
include ../helpers.mk

_src := unzip
_bin := $(_src)/unzip
_install := $(PREFIX)/bin/unzip

_release_ver := 60
_release_tar := unzip.tar.gz
_release_tar_url :=  ftp://ftp.info-zip.org/pub/infozip/src/unzip60.tgz
_md5_sum := 62b490407489521db863b523a7f86375


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	make -C $(_src) -f unix/Makefile clean


.PHONY: uninstall
uninstall:
	make -C $(_src) -j prefix=$(PREFIX) -f unix/Makefile uninstall


.PHONY: download
download: $(_src)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; exit $?) \
		&& tar -xf $(_release_tar) \
		&& mv $(_src)$(_release_ver) $(_src) \
		&& touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	make -C $(_src) -j -f unix/Makefile generic

$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) -j prefix=$(PREFIX) -f unix/Makefile install
