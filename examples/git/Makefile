#!/usr/bin/env make -S -f

# compile EXAMPLE

# EXAMPLE
# is a snippet for compiling a project from a git repository
# clones/updates the repo to the destination, given the url/branch
# writes an 'empty' target named `git-hash` to mark the repo commit
# 	which is then used as a prereq to control compilation
# compiles assuming the normal configure/make/make install steps

# BINARIES PROVIDED
# ...

# LIBRARIES PROVIDED
# ...

# REQUIRES
# ...

# TODO
# [ ] update Makefile variables: _url, _branch, _src, _bin, _install
# [ ] update .gitignore to ignore the source folder
# [ ] update the rules to compile the project depending on it's compilation process
# [ ] update the docs


include ../helpers.mk
PREFIX ?= $(HOME)/.local/
SHELL ?= /bin/bash


_url := EXAMPLE
_branch := master
# destination directory to clone to
_src := EXAMPLE
# local artifact to compile
_bin := $(_src)/bin/EXAMPLE
# installation destination
_install := $(PREFIX)/bin/EXAMPLE


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: uninstall
uninstall:
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) PREFIX=$(PREFIX) uninstall; fi


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -f "$(_src)/Makefile" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_src)/Makefile.in: git-hash
	cd $(_src) \
		&& ./autogen.sh


$(_src)/Makefile: $(_src)/Makefile.in
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX)


$(_bin): $(_src)/Makefile
	$(call log_info,updating $@...)
	make -C $(_src) -j all


$(_install): $(_bin)
	$(call log_info,updating $@...)
	make -C $(_src) PREFIX=$(PREFIX) install
