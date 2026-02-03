#!/usr/bin/env make -S -f

# Flexible I/O tester
# simulates an I/O workload
#
# SEE https://git.kernel.dk/cgit/fio/
# SEE https://fio.readthedocs.io/en/latest/fio_doc.html


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
_src := fio
_branch := master
_bin := $(_src)/fio
_install := $(PREFIX)/bin/fio


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
	rm -rf $(PREFIX)/bin/fio*


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_bin): git-hash
	$(call log_info,updating $@...)
	cd $(_src) \
		&& LDFLAGS+="-L$$HOME/.local/lib" CFLAGS+="-I$$HOME/.local/include" \
		./configure --prefix=$(HOME)/.local
	make -C $(_src) all -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
