#!/usr/bin/make -f

# compile Gnu Awk

# text processor


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_src := gawk
_bin := $(_src)/gawk
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
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: download
download: $(_src)


$(_release_tar):
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(_src):  $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; exit $?) \
		&& tar -xf $(_release_tar) \
		&& mv $(_src)-$(_release_ver) $(_src) \
		&& touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) \
		&& ./configure \
			--prefix=$(PREFIX) \
		&& make -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
