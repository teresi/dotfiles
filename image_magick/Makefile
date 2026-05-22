#!/usr/bin/env make -S -f

# compile ImageMagick

# image processing tool


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local


_url := https://github.com/ImageMagick/ImageMagick.git
_branch := 7.1.2-23
_src := image_magick
_bin := $(_src)/utilities/magick
_install := $(PREFIX)/bin/magick


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then make -j -C $(_src) uninstall; fi


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then make -C $(_src) clean; fi


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash
	touch $@


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) && \
		./configure --prefix=$(PREFIX) --with-modules


$(_bin): $(_src)/Makefile
	$(call log_info,compiling $@...)
	make -j -C $(_src) all


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
