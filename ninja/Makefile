#!/usr/bin/make -f

# compile ninja

# ninja is yet another build system
# ninja is similar to CMAKE


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_install := $(PREFIX)/bin/ninja

_url := https://github.com/ninja-build/ninja.git
_branch := master

_src := ninja
_build := build
_bin := $(_src)/$(_build)/ninja


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	cd $(_src) && cmake --build $(_build) --target clean


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


$(_install): $(_bin)
	$(call log_info,updating $@...)
	cd $(_src) && cmake --build $(_build) --target install -- --no-print-directory


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(call check_pkgs, cmake)
	cd $(_src) \
		&& cmake -B$(_build) --install-prefix=$(PREFIX) \
		&& cmake --build $(_build) -j


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
