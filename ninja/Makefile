#!/usr/bin/make -f

# compile ninja

# ninja is yet another build system
# ninja is similar to CMAKE


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/ninja-build/ninja.git
_branch := master
_src := ninja
_build := build
_bin := $(_src)/$(_build)/ninja
_install := $(PREFIX)/bin/ninja


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then cmake --build $(_src)/$(_build) --target clean; fi


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: repo
repo:
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


.PHONY: download
download: repo


$(_src)/.git: repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(call check_pkgs, cmake)
	@# if `ninja` is up to date but older, the other targets will build
	@# but the timestamp of `ninja` won't update
	@# so update the timestamp manually
	cd $(_src) \
		&& cmake -B$(_build) --install-prefix=$(PREFIX) \
		&& cmake --build $(_build) -j \
		&& (cd ..; if [ -f "$(_bin)" ]; then touch $(_bin); fi)


$(_install): $(_bin)
	$(call log_info,updating $@...)
	cd $(_src) \
		&& cmake --build $(_build) --target install -- --no-print-directory \
		&& if [ -f "$(_install)" ]; then touch $(_install); fi
