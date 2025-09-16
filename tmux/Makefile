#!/usr/bin/env make -S -f

# compile tmux
# tmux is a terminal multiplexer

# REQUIRES
# gcc | clang, pkgconf, libncurses, libevent, yacc | bison

# SEE
# https://github.com/tmux/tmux/wiki/Installing
# https://unix.stackexchange.com/questions/459671/how-do-i-build-tmux-from-source-without-root-access-with-a-custom-built-libevent

PREFIX ?= $(HOME)/.local
include ../helpers.mk

_install := $(PREFIX)/bin/tmux
_url := https://github.com/tmux/tmux.git
_src := tmux
_bin := $(_src)/tmux
_branch := master
_nproc ?= $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: uninstall
uninstall:
	$(MAKE) -C $(_src) uninstall


.PHONY: download
download: repo


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo


$(_bin): $(_src)/.git $(PREFIX)/lib/libevent_core.so $(PREFIX)/lib/libncursesw.so
	$(call log_info,compiling $@...)
	$(call check_binary,bison aclocal autoconf automake gettext libtool)
	@# NB depends on libevent/libncurses SOs in order to enforce a rebuild,
	@#    but this assumes that they are built locally
	@# NB use `--enable-static` so LD_LIBRARY_PATH doesn't have to be set to run
	@#    this is not necessary but simplifies downstream configuration
	@#    the static build increased binary size 5.0MB -> 6.7MB
	PKG_CONFIG_PATH+=:${PREFIX}/lib/pkgconfig \
	cd $(_src) \
		&& sh autogen.sh \
		&& pkg-config --cflags --libs libevent --libs ncurses \
		&& ./configure \
			--prefix="$(PREFIX)" \
			--enable-static


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -C $(_src) install
