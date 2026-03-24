#!/usr/bin/env make -S -f

# compile tig
#
# a TUI for viewing git log


PREFIX ?= $(HOME)/.local
include ../helpers.mk

_url := https://github.com/jonas/tig.git
_src := tig
_branch := tig-2.6.0
_bin := $(_src)/src/tig
_install := $(PREFIX)/bin/tig


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
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_bin): git-hash
	$(call log_info,updating $@...)
	cd $(_src) \
		&& ./autogen.sh \
		&& ./configure --prefix=$(PREFIX) \
		&& $(MAKE) prefix=$(PREFIX) -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) prefix=$(PREFIX) install
