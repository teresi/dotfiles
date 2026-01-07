#!/usr/bin/env make -S -f

# compile Universal CTAGS
#
# generates indexes for navigating source files


include ../helpers.mk
SHELL := /bin/bash
PREFIX ?= $(HOME)/.local/


_url := https://github.com/universal-ctags/ctags.git
_branch := master
_src := ctags
_bin := $(_src)/ctags
_install := $(PREFIX)/bin/ctags


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then make -C $(_src) clean; fi
	rm -f git-hash


.PHONY: uninstall
uninstall:
	make -C $(_src) PREFIX=$(PREFIX) uninstall


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash
	touch $@


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) \
		&& ./autogen.sh \
		&& ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	make -C $(_src) -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# FUTURE: could 'profile-fast-install' improve build time?
	make -C $(_src) PREFIX=$(PREFIX) install
