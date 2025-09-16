#!/usr/bin/env make -S -f

# simplifies include/lib paths during configure and/or make
#
# SEE https://www.linuxfromscratch.org/blfs/view/7.4/general/pkgconfig.html


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://gitlab.freedesktop.org/pkg-config/pkg-config.git
_src := pkg-config
_branch := master
_bin := $(_src)/pkg-config
_install := $(PREFIX)/bin/pkg-config


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	make -C $(_src) uninstall


.PHONY: download
download: repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	cd $(_src) && ./autogen.sh --with-internal-glib --prefix=$(HOME)/.local
	make -C $(_src)


$(_install): $(_bin)
	make -C $(_src) install


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
