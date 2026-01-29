#!/usr/bin/env make -S -f

# compile pkgconf

# tools for path handling during the configure step
# successor to pkg-config
#
# REQIURES
# autoconf automake libtool


include ../helpers.mk
PREFIX ?= $(HOME)/.local/
SHELL ?= /bin/bash


_url := https://github.com/pkgconf/pkgconf.git
_branch := master
_src := pkgconf
_bin := $(_src)/pkgconf
_install := $(PREFIX)/bin/pkgconf


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash
	cd $(_src) && ./autogen.sh


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) \
		&& ./configure \
			--prefix=$(PREFIX) \
			--with-system-libdir=/lib:/usr/lib \
			--with-system-includedir=/usr/include


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	make -C $(_src) -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) PREFIX=$(PREFIX) install
