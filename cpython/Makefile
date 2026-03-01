#!/usr/bin/env make -S -f

# compile cpython


include ../helpers.mk

PREFIX ?= $(HOME)/.local
# NB the commit branch is the same as the python version
_branch ?= 3.14
_url := https://github.com/python/cpython.git
_src := cpython
_bin := $(_src)/python
_install := $(PREFIX)/bin/python$(_branch)


# NOTE devguide.python.org specifies libreadline6-dev but ubuntu22 auto corrects to libreadline-dev
_dep := build-essential gdb lcov pkg-config libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev lzma lzma-dev tk-dev uuid-dev zlib1g-dev


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then make -C $(_src) clean; fi
	rm -f git-hash


.PHONY: uninstall
uninstall:
	rm -rf $(PREFIX)/lib/python$(_branch)
	rm -rf $(PREFIX)/include/python$(_branch)
	rm -rf $(PREFIX)/bin/python$(_branch)
	rm -rf $(PREFIX)/bin/python$(_branch)-config
	rm -rf $(PREFIX)/bin/pydoc$(_branch)


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_src)/Makefile.pre.in: git-hash
	@# update input file mtime to force a rebuild
	touch $@


$(_src)/Makefile: $(_src)/Makefile.pre.in
	$(call log_info,updating $@...)
	@# NB: openssl 3.6.1 was installed to $(PREFIX)/lib64 (NOT lib)
	cd $(_src) \
		&& LDFLAGS=-L$(PREFIX)/.local/lib64 \
		   CPPFLAGS=-I$(PREFIX)/.local/include \
		   PKG_CONFIG_PATH=$(PREFIX)/lib64/pkgconfig:$(PKG_CONFIG_PATH) \
		./configure \
			--prefix=$(PREFIX) \
			--with-openssl=$(PREFIX) \
			--with-openssl-rpath=$(PREFIX)/lib64 \
			--enable-optimizations \
			--with-lto \
			--with-ensurepip=upgrade


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	$(call check_pkgs, $(_dep))
	make -C $(_src) all -j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# NB: use altinstall so previous versions are not overwritten
	make -C $(_src) altinstall -j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))
