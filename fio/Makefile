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
download: repo


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	cd $(_src) \
	&& LDFLAGS+="-L$$HOME/.local/lib" CFLAGS+="-I$$HOME/.local/include" \
		./configure --prefix=$(HOME)/.local
	make -C $(_src) all -j


$(_install): $(_bin)
	$(call log_info,installing $@...)
	make -C $(_src) install
	@# for some strange reason, the `install` target of fio touches the `fio/.git` folder
	@# how? not sure, using `set -x` didn't reveal anything obvious
	@# so touch the targets/folder so the timestamps work properly
	@# if we don't do this, the install target will always rebuild even if it's up to date
	touch $(_bin)
	touch $(_install)


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: repo
