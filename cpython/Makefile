#!/usr/bin/env make -S -f

# compile cpython


include ../helpers.mk

PREFIX ?= $(HOME)/.local
# NB the commit branch is the same as the python version
_branch ?= 3.13
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


.PHONY: uninstall
uninstall:
	rm -rf $(PREFIX)/lib/python$(_branch)
	rm -rf $(PREFIX)/include/python$(_branch)
	rm -rf $(PREFIX)/bin/python$(_branch)
	rm -rf $(PREFIX)/bin/python$(_branch)-config
	rm -rf $(PREFIX)/bin/pydoc$(_branch)


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


.PHONY: download
download: repo


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(call check_pkgs, $(_dep))
	cd $(_src) \
		&& ./configure \
			--prefix=$(PREFIX) \
			--enable-optimizations \
			--with-lto \
			--with-ensurepip=upgrade
	make -C $(_src) all -j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) altinstall -j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))
