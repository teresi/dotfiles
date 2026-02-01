#!/usr/bin/env make -S -f

# compile tig
#
# a TUI for viewing git log


PREFIX ?= $(HOME)/.local
include ../helpers.mk

_url := https://github.com/jonas/tig.git
_src := tig
_branch := master
_bin := $(_src)/src/tig
_install := $(PREFIX)/bin/tig


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) prefix=$(PREFIX) uninstall


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(MAKE) -C $(_src) prefix=$(PREFIX) -j
	@# BUG: needs ncursesw but can't find the headers? does it need CFLAGS?
	@# LDFLAGS+="-L$$HOME/.local/lib" CFLAGS+="-I$$HOME/.local/include" \


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) prefix=$(PREFIX) install
