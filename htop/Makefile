#!/usr/bin/make -f

# compile htop

# HTOP provides a TUI process viewer


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/htop-dev/htop.git
_src := htop/htop
_bin := $(_src)/htop
_branch := main
_install := $(PREFIX)/bin/htop


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: download
download: repo


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_src) install


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(call check_binary, autoconf automake gettext libtool pkgconf)
	$(call check_pkgs, libncurses-dev)
	cd $(_src) && ./autogen.sh && ./configure --prefix=$(PREFIX)
	$(MAKE) -ik -C $(_src)


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
