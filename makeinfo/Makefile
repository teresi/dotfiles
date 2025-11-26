#!/usr/bin/env make -S -f

# compile texinfo package
#
# texinfo compiles documenation
# binaries: info, infokey, install-info, makeinfo, texi2dvi and texindex


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_src := texinfo
_bin := $(_src)/texindex/texindex
_install := $(PREFIX)/bin/texindex

_release_ver := 7.2
_tar := texinfo-$(_release_ver).tar.gz
_sig := texinfo-$(_release_ver).tar.gz.sig
_release_tar_url := https://ftp.gnu.org/gnu/texinfo/texinfo-$(_release_ver).tar.gz
_release_sig_url := https://ftp.gnu.org/gnu/texinfo/texinfo-$(_release_ver).tar.gz.sig

_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
# MAGIC: Gavin Smiths key ID, this is specific to the signature file
# SEE:  `gpg -d <file>.tar.gz.sig`
_gpg_id  := EAF669B31E31E1DECBD11513DDBC579DAB37FBA9


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


$(_bin): $(_src)
	$(call log_info,updating $@...)
	cd $(_src) && ./configure --prefix=$(HOME)/.local
	$(MAKE) -j -C $(_src)
	$(call log_info,updating $@...    COMPLETE!)


$(_install): $(_src)
	$(call log_info,updating $@...)
	$(MAKE) -j -C $(_src) -j install
	$(call log_info,updating $@...    COMPLETE!)


$(_gpg_key):
	curl -C - -o $(_gpg_key) $(_gpg_url)


$(_sig):
	curl -C - -o $(_sig) $(_release_sig_url)


$(_tar):
	curl -C - -o $(_tar) $(_release_tar_url)


$(_src):  $(_sig) $(_tar) $(_gpg_key)
	$(call log_info, verifying signature $(_sig)...)
	gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys $(_gpg_id) \
		|| gpg --import ./$(_gpg_key)
	gpg --verify --keyring ./$(_gpg_key) ./$(_sig) \
		|| (echo "invalid sig"; exit 1)
	$(call log_info,extracting source directory $@...)
	gpg --verify ./$(_sig) ./$(_tar) \
		|| (echo "invalid tar"; exit 1) \
		&& (mkdir -p ./$(_src) && tar -xzvf ./$(_tar) -C ./$(_src)/ --strip-components=1)
	@# update timestamp of uncompressed dir to now
	touch $(_src)
