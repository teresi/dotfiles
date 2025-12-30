#!/usr/bin/env make -S -f

# compile libedit
# "This is an autotool- and libtoolized port of the NetBSD Editline library (libedit)."
# tool similar to gnu readline

# requires
# aclocal 1.18+

include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local


_url := https://salsa.debian.org/debian/libedit.git
_branch := master
_src := libedit
_bin := $(_src)/src/.libs/libedit.so
_install := $(PREFIX)/lib/libedit.so


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then make -C $(_build) clean; fi


.PHONY: uninstall
uninstall:

	if [ -f "$(_manifest)" ]; then xargs rm -f < $(_manifest); fi


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash | $(_src)


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) && ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -j -C $(_src) all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
