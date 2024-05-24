#!/usr/bin/make -f

# compile bison

# bison is a parser generator for GNU
# it is a translator used to generate other source files
# it is similar to Yet Another Compiler Compile (YACC)


SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFLAGS += --no-print-directory
PREFIX := $(HOME)/.local/bin

BISON_DIR := $(ROOT_DIR)/bison
BISON_BIN := $(PREFIX)/bison


.PHONY: all
all: $(BISON_BIN)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(BISON_DIR) clean


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(BISON_DIR) uninstall
	rm -r $(BISON_BIN)


$(BISON_BIN):
	$(ROOT_DIR)/bison.bash $(PREFIX)
