#!/usr/bin/make -f

# compile tmux


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
	rm -f $(NCURSES_LIB)
	$(MAKE) -ik clean -C $(NCURSES_DIR)
	rm -f $(LIBEVENT_LIB)
	$(MAKE) -ik clean -C $(LIBEVENT_DIR)/build
	rm -f $(TMUX_BIN)
	$(MAKE) -ik clean -C $(TMUX_DIR)


$(NCURSES_LIB):
	$(ROOT_DIR)/ncurses.bash $(PREFIX)


$(LIBEVENT_LIB):
	$(ROOT_DIR)/libevent.bash $(PREFIX)


# not compiling libevent/ncurses for now, see note in tmux script
#$(TMUX_BIN): | $(LIBEVENT_LIB) $(NCURSES_LIB)
$(TMUX_BIN):
	$(ROOT_DIR)/tmux.bash $(PREFIX)

