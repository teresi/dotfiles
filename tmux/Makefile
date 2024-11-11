#!/usr/bin/make -f

# compile tmux

# requires pkgconf, libncurses, libevent


SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFLAGS += --no-print-directory
PREFIX := $(HOME)/.local

NCURSES_DIR := $(ROOT_DIR)/ncurses
NCURSES_LIB = $(PREFIX)/lib/libncurses.a

LIBEVENT_DIR := $(ROOT_DIR)/libevent
LIBEVENT_LIB := $(PREFIX)/lib/libevent.so

TMUX_DIR := $(ROOT_DIR)/tmux
TMUX_BIN := $(PREFIX)/bin/tmux


.PHONY: all
all: $(TMUX_BIN)


.PHONY: clean
clean:
	$(MAKE) -ik clean -C $(TMUX_DIR)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(TMUX_DIR) uninstall


# we compile libevent now in the top level makefile
# skipping ncurses compile b/c I get a warning for
# libtinfo.so.6 no version information available
# every time it's used
$(TMUX_BIN):
	$(ROOT_DIR)/tmux.bash $(PREFIX)

