#!/usr/bin/make -f

# compile latest release of libevent


include ../helpers.mk
PREFIX ?= $(HOME)/.local
export PATH := $(PREFIX)/bin:$(PATH)

_URL := https://github.com/libevent/libevent.git
_DIR := ./libevent
_BUILD := $(_DIR)/build
_BRANCH := release-2.1.12-stable
_BIN := $(_BUILD)/lib/libevent.so
_INSTALL := $(PREFIX)/lib/libevent.so
_depends := cmake


.PHONY: all
all: $(_BIN)


.PHONY: install
install: $(_INSTALL)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_BUILD) uninstall
	rm -rf $(DIR)


.PHONY: check
check:
	$(foreach prog,$(_depends),type -t $(prog) 2>&1 >/dev/null || (echo "dependency not in PATH: $(prog)"; exit 1);)


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
