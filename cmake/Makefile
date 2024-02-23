#!/usr/bin/make -f

# compile latest release of CMake


include ../helpers.mk

PREFIX := $(HOME)/.local

_URL := https://github.com/Kitware/CMake.git
_DIR := ./cmake
_BUILD := $(_DIR)/build
_BRANCH := release
_BIN := $(PREFIX)/bin/cmake


$(_BIN): | repo
	$(call log_info,updating $@...)
	mkdir -p $(_BUILD) && cd $(_BUILD) \
		&& ../bootstrap --prefix=$(PREFIX) --parallel=$(shell nproc)
	@# NB using a low core count b/c cmake uses a lot of ram per core
	$(MAKE) -ik -C $(_BUILD) -j 2
	$(MAKE) -ik -C $(_BUILD) -j install
	$(call log_info,updating $@...    COMPLETE!)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_BUILD) clean


.PHONY: repo
repo:
	$(call update_repo,$(_URL),$(_DIR),$(_BRANCH))


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_BUILD) uninstall
