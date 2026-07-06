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
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi
	touch $(_src)/Makefile.in


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
	@# the new openssl installs to lib64, not lib
	cd $(_src) \
		&& autoreconf -fi \
		&& \
			PKG_CONFIG_PATH="${HOME}/.local/lib64/pkgconfig:${HOME}/.local/lib/pkgconfig:${PKG_CONFIG_PATH}" \
			./configure \
				--with-openssl="${HOME}/.local" \
				--with-libpsl="${HOME}/.local" \
				--enable-versioned-symbols \
				--prefix=$(PREFIX) \
			LDFLAGS="-L${HOME}/.local/lib64 -L${HOME}/.local/lib -Wl,-rpath,${HOME}/.local/lib64 -Wl,-rpath,${HOME}/.local/lib" \
			CFLAGS="-I${HOME}/.local/include"


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -C $(_src) -j $$((`nproc`>1 ? `nproc`-1 : 1))


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) -j install
