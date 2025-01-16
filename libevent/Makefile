#!/usr/bin/make -f

# compile latest release of libevent


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/libevent/libevent.git
_src := libevent
_build := $(_src)/build
_branch := release-2.1.12-stable
_bin := $(_build)/lib/libevent.so
_install := $(PREFIX)/lib/libevent.so
_nproc ?= $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_build) clean; fi


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_build) uninstall


.PHONY: download
download: repo


$(_build):
	mkdir -p $(_build)


$(_bin): $(_src)/.git | $(_build)
	$(call log_info,updating $@...)
	$(call check_binary,cmake)
	cd $(_build) && \
		cmake .. -DCMAKE_INSTALL_PREFIX=$(PREFIX)
	$(MAKE) -ik -C $(_build) -j $(_nproc) all
	$(call log_info,updating $@...    COMPLETE!)


$(_install): $(_src)/.git
	$(MAKE) -ik -C $(_build) install


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
