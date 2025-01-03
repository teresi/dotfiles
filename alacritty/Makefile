#!/usr/bin/make -f

# compile alacritty
#
# alacritty is a GPU accelerated terminal
#
# SEE https://alacritty.org/


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_install := $(PREFIX)/bin/alacritty

_url := https://github.com/alacritty/alacritty.git

_src := alacritty
_bin := $(_src)/target/release/alacritty

# using 18 b/c this what ODIN uses (note that they use 'main', not 'master')
_branch := master
_depth ?=
# using half the cores b/c compiling/linkng llvm uses a lot of cpu/ram
_nproc := $(shell echo $$(( `nproc` / 2 )))


.PHONY: all
all: $(_bin)


.PHONY: install
install: $(_install)


.PHONY: clean
clean:
	cd $(_src) && ninja -C $(_build) --target clean


.PHONY: uninstall
uninstall:
	xargs rm -f < $(_src)/$(_build)/install_manifest.txt


.PHONY: repo
repo:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch),$(_depth))


$(_src)/.git: | repo


$(_bin): $(_src)/.git
	$(call log_info,compiling $@...)
	$(call log_info,please wait...)
	$(call check_pkgs,gcc-multilib)
	$(call check_binary,cmake)
	$(call check_binary,ninja)
	cd $(_src) \
		&& cargo +stable build -j $(nproc) --release


$(_install): $(_bin)
	$(call log_info,updating $@...)
	cd $(_src) \
		&& ninja -C build install
