#!/usr/bin/env make -S -f

# compile latest release of CMake


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/Kitware/CMake.git
_src := cmake
_branch := release
_build := $(_src)/build
_bin := $(_build)/bin/cmake
_install := $(PREFIX)/bin/cmake


.PHONY: all
all: $(_build)/bin/cmake


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	@# NB: we *could* call clean from the build folder
	@#if [ -d "$(_src)" ]; then make -C $(_build) clean; fi
	@# *but* this is not reliable (it's a cmake project), so delete the build folder
	rm -rf $(_build)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_build) uninstall; fi


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_build):
	mkdir -p $(_build)


$(_bin): git-hash | $(_build)
	$(call log_info,updating $@...)
	cd $(_build) \
		&& LDFLAGS+=" -L${HOME}/.local/lib" CFLAGS+=" -L${HOME}/.local/include" PKG_CONFIG_PATH+=":${HOME}/.local/lib/pkgconfig" \
		../bootstrap --prefix=$(PREFIX) --parallel=$(shell nproc)
	@# NB using a low core count b/c cmake uses a lot of ram per core
	$(MAKE) -ik -C $(_build) -j 3
	$(call log_info,updating $@...    COMPLETE!)


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_build) -j install
	$(call log_info,updating $@...    COMPLETE!)
