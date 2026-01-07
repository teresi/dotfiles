#!/usr/bin/env make -S -f

# compile curl

# CURL up/downloads files given URLs
#
# requires
# libpsl, libidn2, libunistring, libzstd


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/curl/curl.git
_src := curl
_branch := curl-8_15_0
_bin := $(_src)/src/curl
_install := $(PREFIX)/bin/curl


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
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash
	touch $@


$(_src)/Makefile: $(_src)/Makefile.in
	@# need to include the pkg_config_path in case we have a local dependency (e.g. libzstd)
	cd $(_src) \
		&& autoreconf -fi \
		&& LDFLAGS+=" -L${HOME}/.local/lib" CFLAGS+=" -L${HOME}/.local/include" PKG_CONFIG_PATH+=":${HOME}/.local/lib/pkgconfig" \
			./configure --with-openssl --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -C $(_src) -j $$((`nproc`>1 ? `nproc`-1 : 1))


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) -j install
