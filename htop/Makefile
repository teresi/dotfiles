#!/usr/bin/make -f

# compile htop


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_URL := https://github.com/htop-dev/htop.git
_SRC := $(ROOT_DIR)/htop/htop
#_BIN := $(or $(shell command -v htop), $(PREFIX)/bin/htop)
_BIN := $(_SRC)/htop
_BRANCH := main


.PHONY: all
all: $(_BIN)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(_SRC) clean


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_SRC) uninstall


.PHONY: install
install:
	$(MAKE) -ik -C $(_SRC) install


$(PREFIX)/bin/htop: install


$(_BIN): $(_SRC)/.git | $(_SRC)
	$(call log_info,updating $@...)
	$(call check_pkgs, autoconf automake autotools-dev libncurses-dev)
	cd $(_SRC) && ./autogen.sh && ./configure --prefix=$(PREFIX)
	$(MAKE) -ik -C $(_SRC)


.PHONY: $(_SRC)
$(_SRC):
	$(call git_clone_fetch_reset,$(_URL),$(_SRC),$(_BRANCH))
