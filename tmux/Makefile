#!/usr/bin/make -f

# compile tmux


SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFLAGS += --no-print-directory
PREFIX := $(HOME)/.local

NCURSES_DIR := $(ROOT_DIR)/ncurses
NCURSES_LIB = $(PREFIX)/lib/ncurses.a

LIBEVENT_DIR := $(ROOT_DIR)/libevent

TMUX_DIR := $(ROOT_DIR)/tmux


.PHONY: clean
clean:
	$(MAKE) -ik $(NCURSES_DIR) clean


$(NCURSES_LIB):
	$(ROOT_DIR)/ncurses.bash $(PREFIX)


# TODO compile libevent


# TODO compile tmux
