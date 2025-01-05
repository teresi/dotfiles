#!/usr/bin/make -f

# compile htop


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_URL := https://github.com/htop-dev/htop.git
_SRC := $(ROOT_DIR)/htop/htop
#_BIN := $(or $(shell command -v htop), $(PREFIX)/bin/htop)
_BIN := $(_SRC)/htop
_BRANCH := main
_INSTALL := $(PREFIX)/bin/htop


.PHONY: all
all: $(_BIN)


.PHONY: install
install: $(_INSTALL)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_SRC) clean


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_SRC) uninstall


$(_INSTALL): $(_BIN)
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_SRC) install


$(_BIN): $(_SRC)/.git | $(_SRC)
	$(call log_info,updating $@...)
	$(call check_binary, autoconf automake gettext libtool pkgconf)
	$(call check_pkgs, libncurses-dev)
	cd $(_SRC) && ./autogen.sh && ./configure --prefix=$(PREFIX)
	$(MAKE) -ik -C $(_SRC)


.PHONY: $(_SRC)
$(_SRC):
	$(call git_clone_fetch_reset,$(_URL),$(_SRC),$(_BRANCH))
