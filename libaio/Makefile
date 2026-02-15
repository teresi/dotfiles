#!/usr/bin/env make -S -f

# linux asynchronous I/O library
# SEE https://pagure.io/libaio
# SEE https://git.kernel.dk/cgit/fio/


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://pagure.io/libaio.git
_branch := master
_src := libaio
_bin := $(_src)/src/libaio.a
_install := $(PREFIX)/lib/libaio.a


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	rm -rf $(PREFIX)/lib/libaio*
	rm -rf $(PREFIX)/include/libaio*


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_bin): git-hash
	$(call log_info,updating $@...)
	make -C $(_src) prefix=$(PREFIX) all


$(_install): $(_bin)
	make -C $(_src) prefix=$(PREFIX) install
