#!/usr/bin/env make -S -f

# compile texinfo
#
# texinfo compiles documenation
# binaries: info, infokey, install-info, makeinfo, texi2dvi and texindex


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://git.savannah.gnu.org/git/texinfo.git
_src := texinfo
_branch := master
_bin := $(_src)/texindex/texindex
_install := $(PREFIX)/bin/texindex


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_build) clean; fi


.PHONY: install
install: $(_install)


.PHONY: download
download: repo


$(_install): $(_src)/.git
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_src) -j install
	$(call log_info,updating $@...    COMPLETE!)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	cd $(_src) \
		&& ./autogen.sh \
		&& ./configure --prefix=$(HOME)/.local
	$(MAKE) -ik -C $(_src)
	$(call log_info,updating $@...    COMPLETE!)


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
