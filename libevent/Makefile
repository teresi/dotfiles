#!/usr/bin/env make -S -f

# libevent
#
# PROVIDES
# library for callbacks
#
# REQUIRES
# cmake, libssl-dev


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/libevent/libevent.git
_src := libevent
_build := $(_src)/build
_branch := release-2.1.12-stable
_bin := $(_build)/lib/libevent.a
_install := $(PREFIX)/lib/libevent.a


.PHONY: all
all: $(_bin)


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
	$(MAKE) -ik -C $(_build) uninstall


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_build):
	mkdir -p $(_build)


$(_bin): git-hash | $(_build)
	$(call log_info,updating $@...)
	$(call check_binary,cmake)
	@# autotools is available but is deprecated since 2.2
	@# use CMAKE_POLICY_VERSION_MINIMUM so it works for newer versions of cmake
	cd $(_build) && \
		cmake .. \
		-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
	$(MAKE) -ik -C $(_build) all \
		-j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# manually update install timestamp on success,
	@# otherwise the install will always reinstall
	$(MAKE) -ik -C $(_build) install  && touch $(_install)
