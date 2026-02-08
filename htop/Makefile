#!/usr/bin/env make -S -f

# compile htop

# HTOP provides a TUI process viewer

# REQUIRES
# make, autoconf, automake, gettext, libtool, pkgconf, libncurses


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/htop-dev/htop.git
_branch := main
_src := htop
_bin := $(_src)/htop
_install := $(PREFIX)/bin/htop


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
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash
	cd $(_src) \
		&& ./autogen.sh


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	make -C $(_src) -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) PREFIX=$(PREFIX) install
