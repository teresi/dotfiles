#!/usr/bin/make -f

# compile luarocks

# a package manager for lua modules


include ../helpers.mk
PREFIX ?= $(HOME)/.local

_url := https://github.com/luarocks/luarocks.git
_src := luarocks
_bin := $(_src)/build/luarocks
_branch := main
_install := $(PREFIX)/bin/luarocks


.PHONY: all
all: repo $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	if [ -d "$(_src)" ]; then $(MAKE) -ik -C $(_src) clean; fi


.PHONY: uninstall
uninstall:
	$(MAKE) -ik -C $(_src) uninstall


.PHONY: download
download: repo


$(_install): $(_bin)
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $(_src) install


$(_bin): $(_src)/.git
	$(call log_info,updating $@...)
	$(call check_binary, unzip lua)
	$(call check_pkgs, build-essential libreadline-dev)
	cd $(_src) \
		&& ./configure --prefix=$(PREFIX) --with-lua-include=$(PREFIX)/include --with-lua=$(PREFIX)
	$(MAKE) -ik -C $(_src)


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


$(_src)/.git: | repo
