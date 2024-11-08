#!/usr/bin/make -f

# compile latest release of CMake


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_URL := https://github.com/Kitware/CMake.git
_DIR := ./cmake
_BUILD := $(_DIR)/build
_BRANCH := release
_BIN := $(PREFIX)/bin/cmake


.PHONY: all
all: $(_BUILD)/bin/cmake


.PHONY: install
install: $(_BIN)


$(_BIN): $(_DIR)/.git
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_BUILD) -j install
	$(call log_info,updating $@...    COMPLETE!)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_BUILD) uninstall


$(_BUILD)/bin/cmake: $(_DIR)/.git
	$(call log_info,updating $@...)
	mkdir -p $(_BUILD) && cd $(_BUILD) \
		&& ../bootstrap --prefix=$(PREFIX) --parallel=$(shell nproc)
	@# NB using a low core count b/c cmake uses a lot of ram per core
	$(MAKE) -ik -C $(_BUILD) -j 2
	$(call log_info,updating $@...    COMPLETE!)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_BUILD) clean || rm -rf $(_DIR)


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_URL),$(_DIR),$(_BRANCH))


$(_DIR)/.git: | repo
