#!/usr/bin/env make -S -f

# compile ninja
#
# ninja is yet another build system
# ninja is similar to CMAKE

# BINARIES PROVIDED
# ninja

# REQUIRES
# cmake


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/ninja-build/ninja.git
_branch := release
_src := ninja
_build := build
_bin := $(_src)/$(_build)/ninja
_install := $(PREFIX)/bin/ninja


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	@# the only way to be sure a cmake project is clean is by deleting the build folder
	rm -rf $(_src)/$(_build)
	@# always force a rebuild
	rm -f $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_build):
	mkdir -p $(_build)


$(_bin): git-hash | $(_build)
	$(call log_info,updating $@...)
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
