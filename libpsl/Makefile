#!/usr/bin/make -f

# libpsl
# C library to handle the Public Suffix List

# psl			# binary
# libpsl.so		# lib
#
# dependency of CURL

# requires
#	libidn2
#	libunistring
#	pkg-config (installed to HOME!)

include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/rockdaboot/libpsl.git
_branch := master

_src := libpsl
_bin := $(_src)/tools/psl
_install := $(PREFIX)/bin/psl


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	make -C $(_src) clean


.PHONY: uninstall
uninstall:
	make -C $(_src) uninstall


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call log_info,    checking submodules...)
	cd $(_src) \
		&& git submodule update --init --recursive
	@# using `autoreconf -fi` fails, but `autoreconf -i` succeeds
	cd $(_src) \
		&& ./autogen.sh \
		&& LDFLAGS+="-L$$HOME/.local/lib" CFLAGS+="-I$$HOME/.local/include" \
			./configure --prefix=$(PREFIX)
	make -C $(_src) -j
	make -C $(_src) -j check


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) install
