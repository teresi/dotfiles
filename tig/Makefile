#!/usr/bin/make -f

# compile tig
#
# a TUI for viewing git log


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_URL := https://github.com/jonas/tig.git
_DIR := ./tig
_BRANCH := master
_BIN := $(_DIR)/src/tig
_INSTALL := $(PREFIX)/bin/tig


.PHONY: all
all: $(_BIN)


.PHONY: install
install: $(_INSTALL)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_DIR) prefix=$(PREFIX) uninstall


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_DIR) prefix=$(PREFIX) clean


$(_INSTALL): $(_BIN)
	$(call log_info,updating $@...)
	make -C $(_DIR) prefix=$(PREFIX) install


$(_BIN): $(_DIR)/.git
	$(call log_info,updating $@...)
	$(MAKE) -C $(_DIR) prefix=$(PREFIX) -j


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_URL),$(_DIR),$(_BRANCH))


$(_DIR)/.git: | repo
