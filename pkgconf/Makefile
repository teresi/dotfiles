#!/usr/bin/env make -S -f

# compile pkgconf

# tools for path handling during the configure step
# successor to pkg-config


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/

_src := pkgconf
_bin := $(_src)/pkgconf
_install := $(PREFIX)/bin/pkgconf

_release_ver := 2.1.1
_release_tar := pkgconf-$(_release_ver).tar.xz
_release_tar_url := https://distfiles.ariadne.space/pkgconf/pkgconf-2.1.1.tar.xz
_md5_sum := bc29d74c2483197deb9f1f3b414b7918


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


$(_src): $(_release_tar)
	[[ `md5sum < $(_release_tar)` = "$(_md5_sum)  -" ]] \
		|| (echo "md5sum check failed: $(_release_tar)"; exit $?) \
		&& tar -xf $(_release_tar) \
		&& mv $(_src)-$(_release_ver) $(_src)
	touch $(_src)


$(_bin): $(_src)
	$(call log_info,compiling $@...)
	cd $(_src) \
		&& ./configure \
			--prefix=$(PREFIX) \
		&& make -j


$(_install): $(_bin)
	$(call log_info,installling $@...)
	make -C $(_src) install
