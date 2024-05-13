#!/usr/bin/make -f

# compile ninja


SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFLAGS += --no-print-directory
PREFIX := $(HOME)/.local/bin

NINJA_DIR := $(ROOT_DIR)/ninja
NINJA_BIN := $(PREFIX)/ninja


.PHONY: all
all: $(NINJA_BIN)


.PHONY: clean
clean:
	rm -f $(NINJA_BIN)
	cmake --build $(NINJA_DIR)/build-cmake/ --target clean


$(NINJA_BIN):
	$(ROOT_DIR)/ninja.bash $(PREFIX)

