#!/usr/bin/env make -S -f

# compile latest release of CMake


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/Kitware/CMake.git
_src := cmake
_build := $(_src)/build
_branch := release
_bin := $(PREFIX)/bin/cmake


.PHONY: all
all: $(_build)/bin/cmake


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_build) clean; fi


.PHONY: install
install: $(_bin)


.PHONY: download
download: repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_build) -j install
	$(call log_info,updating $@...    COMPLETE!)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_build) uninstall


$(_build)/bin/cmake: $(_src)/.git
	$(call log_info,updating $@...)
	mkdir -p $(_build) && cd $(_build) \
		&& LDFLAGS+=" -L${HOME}/.local/lib" CFLAGS+=" -L${HOME}/.local/include" PKG_CONFIG_PATH+=":${HOME}/.local/lib/pkgconfig" \
		../bootstrap --prefix=$(PREFIX) --parallel=$(shell nproc)
	@# NB using a low core count b/c cmake uses a lot of ram per core
	$(MAKE) -ik -C $(_build) -j 2
	$(call log_info,updating $@...    COMPLETE!)


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
