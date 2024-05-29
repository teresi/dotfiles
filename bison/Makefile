#!/usr/bin/make -f

# compile bison

# bison is a parser generator for GNU
# it is a translator used to generate other source files
# it is similar to Yet Another Compiler Compile (YACC)
#
# FUTURE refactor bash script into this makefile


SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/bin

_root_dir := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
BISON_DIR := $(_root_dir)/bison
BISON_BIN := $(PREFIX)/bison

_release_ver := 3.8.2
_release_sig := $(_root_dir)/bison-$(_release_ver).tar.gz.sig
_release_sig_url := https://ftp.gnu.org/gnu/bison/bison-$(_release_ver).tar.gz.sig
_release_tar=$(_root_dir)/bison-$(_release_ver).tar.gz
_release_tar_url=https://ftp.gnu.org/gnu/bison/bison-$(_release_ver).tar.gz

.PHONY: all
all: $(BISON_BIN)


.PHONY: clean
clean:
	$(MAKE) -ik -C $(BISON_DIR) clean
	rm $(_release_sig)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(BISON_DIR) uninstall
	rm -r $(BISON_BIN)


bison-3.8.2.tar.gz.sig:
	curl -C - -o $(_release_sig) $(_release_sig_url)


bison-3.8.2.tar.gz:
	curl -C - -o $(_release_tar) $(_release_tar_url)


$(BISON_BIN): bison-3.8.2.tar.gz.sig
	$(_root_dir)/bison.bash $(PREFIX)
