#!/usr/bin/make -f

# compile latest release of libevent


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_URL := https://github.com/libevent/libevent.git
_DIR := ./libevent
_BUILD := $(_DIR)/build
_BRANCH := release
_BIN := $(_BUILD)/lib/libevent.so
_INSTALL := $(PREFIX)/lib/libevent.so


.PHONY: all
all: $(_BIN)


.PHONY: install
install: $(_INSTALL)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_BUILD) uninstall


$(_BIN): $(_DIR)/.git
	$(call log_info,updating $@...)
	mkdir -p $(_BUILD) && cd $(_BUILD) && \
		cmake .. -DCMAKE_INSTALL_PREFIX=$(PREFIX)
	$(MAKE) -ik -C $(_BUILD) -j all
	$(call log_info,updating $@...    COMPLETE!)


$(_INSTALL): $(_DIR)/.git
	$(MAKE) -ik -C $(_BUILD) install


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_BUILD) clean


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_URL),$(_DIR),$(_BRANCH))


$(_DIR)/.git: | repo
