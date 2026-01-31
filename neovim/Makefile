#!/usr/bin/env make -S -f

# compile neovim

# NEOVIM is an editor and successor to vim
#
# REQUIRES
# ninja gettext libtool autoconf automake cmake g++ pkg-config unzip curl



include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/neovim/neovim.git
_branch := master
_src := neovim
_bin := $(_src)/build/bin/nvim
_install := $(PREFIX)/bin/nvim


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) distclean; fi


.PHONY: uninstall
uninstall:
	@# uninstall binaries
	[[ -d "$(_src)" ]] && xargs rm -f < $(_src)/build/install_manifest.txt
	@# uninstall plugins
	rm -rf $(PREFIX)/share/nvim


.PHONY: download
download:
	@# creates or updates repo at $(_src)
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	@# git-hash is updated when the local repo commit is changed
	$(call check_commit, $(_src))


$(_bin): git-hash
	$(call log_info,compiling $@...)
	@# -j not needed w/ ninja
	make -C $(_src) \
		CMAKE_BUILD_TYPE=Release \
		CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$(PREFIX)"


$(_install): $(_bin)
	$(call log_info,updating $@...)
	@# -j not needed w/ ninja
	make -C $(_src) \
		install
