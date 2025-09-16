#!/usr/bin/env make -S -f

# linux asynchronous I/O library
# SEE https://pagure.io/libaio
# SEE https://git.kernel.dk/cgit/fio/


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://pagure.io/libaio.git
_src := libaio
_branch := master
_bin := $(_src)/src/libaio.a
_install := $(PREFIX)/lib/libaio.a


.PHONY: all
all: $(_bin)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	rm -rf $(PREFIX)/lib/libaio*
	rm -rf $(PREFIX)/include/libaio*


.PHONY: download
download: repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	make -C $(_src) prefix=$(PREFIX) all


$(_install): $(_bin)
	make -C $(_src) prefix=$(PREFIX) install


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
