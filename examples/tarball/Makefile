#!/usr/bin/env make -S -f

# compile <EXAMPLE>
#
# <EXAMPLE> is snippet compiling a source from a tarball
#
# <EXAMPLE> provides the binaries:
#
# TODO: needs updates according the the package:
# - docstrings
# - constants
# - clean rule
# - $(_bin) rule
# - $(_install) rule


include ../helpers.mk
PREFIX ?= $(HOME)/.local

# MAGIC: the local folder, the bin|lib produced, and it's install location
_src := <EXAMPLE>
_bin := $(_src)/path/to/one/of/the/binaries
_install := $(PREFIX)/<bin or lib>/one/of/the/targets

# MAGIC: the files / uris from the gnu FTP
_ver := <VERSION>
_tar := <NAME>-$(_ver).tar.gz
_sig := <NAME>-$(_ver).tar.gz.sig
_release_tar_url := https://ftp.gnu.org/gnu/<NAME>/<NAME>-$(_ver).tar.gz
_release_sig_url := https://ftp.gnu.org/gnu/<NAME>/<NAME>-$(_ver).tar.gz.sig

# MAGIC: verify the tarball with it's signature,
# by first importing the expected key, then run gpg --verify
_gpg_key := gnu-keyring.gpg
_gpg_url := https://ftp.gnu.org/gnu/gnu-keyring.gpg
# MAGIC: John Doe's key ID (specific to the signature file) run `gpg -d <file>.tar.gz.sig`
_gpg_id  := ABC123ABC123ABC123ABC123ABC123ABC123ABC1



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


$(_install): $(_src)/.git
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
