#!/usr/bin/env make -S -f

# compile cmatrix
#
# displays the matrix in your terminal


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/abishekvashok/cmatrix.git
_src := cmatrix
_branch := master
_bin := $(_src)/cmatrix
_install := $(PREFIX)/bin/cmatrix


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then make -C $(_src) clean; fi


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_build) uninstall; fi


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_bin): git-hash
	$(call log_info,updating $@...)
	cd $(_src) && \
	autoreconf -i && \
	LDFLAGS=-L$(PREFIX)/lib \
	CPPFLAGS="-I$(PREFIX)/include/ncursesw -I$(PREFIX)/include" \
	PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig:"$$PKG_CONFIG_PATH" \
	LIBS=-lncursesw \
			./configure --prefix $(PREFIX) \
			&& make  -j


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_src) -j install
