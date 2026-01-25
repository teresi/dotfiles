#!/usr/bin/env make -S -f

# compile alacritty
#
# alacritty is a GPU accelerated terminal
#
# SEE https://alacritty.org/
# NB  the binary is installed to one's cargo bin directory,
#     which is setup after installing rust
# NB  while one could also use `cargo install alacritty`,
#     this script provides additonal post install settings


include ../helpers.mk
PREFIX ?= $(HOME)/.local
_root_dir := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
_depends := libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

_url := https://github.com/alacritty/alacritty.git
_src := alacritty
_bin := $(_src)/target/release/alacritty
_branch := master

# MAGIC this is typically where font config installs fontconfig.pc
_pkg_conf := $(shell echo /usr/lib/`gcc -dumpmachine`/pkgconfig)

_cargo_install := $(CARGO_INSTALL_ROOT)
ifeq ($(_cargo_install),)
	_cargo_install := $(CARGO_HOME)
endif
ifeq ($(_cargo_install),)
	_cargo_install := $(HOME)/.cargo
endif
_cargo_bin := $(_cargo_install)/bin/alacritty
_bash_complete_script := $(_src)/alacritty/extra/completions/alacritty.bash
_source_bash_comp := $(HOME)/.bash_completion/alacritty.bash


.PHONY: all
all: $(_bin)
	$(call log_info,alacritty compiled to $(_bin))


.PHONY: install
install: $(_cargo_bin) $(_source_bash_comp)
	$(call log_info,alacritty installed to $(_cargo_bin))

	$(call log_info,    updating terminfo)
	infocmp alacritty > /dev/null \
		|| (cd $(_src) && tic -xe alacritty,alacritty-direct extra/alacritty.info)

	$(call log_info,    update default cinnamon terminal...)
	dconf write /org/cinnamon/desktop/applications/terminal/exec "'$(_cargo_bin)'" || true
	dconf write /org/cinnamon/desktop/keybindings/media-keys/terminal "['<Primary><Alt>t']" || true

	$(call log_info,    source alacritty bash completions in bashrc...)
	grep -q "source $(_source_bash_comp)" $(HOME)/.bashrc \
		|| echo "[ -r $(_source_bash_comp) ] && source $(_source_bash_comp)" >> $(HOME)/.bashrc


.PHONY: clean
clean:
	$(call log_info,clean $(_src))
	cargo clean --manifest-path $(_src)/Cargo.toml


.PHONY: uninstall
uninstall:
	$(call log_info,uninstall $(_src))
	rm $(_install)
	cargo uninstall alacritty


.PHONY: download
download:
	$(call git_clone_fetch_reset,$(_url),$(_src),$(_branch))


git-hash: download
	$(call check_commit, $(_src))


.PHONY: check_cargo_install
check_cargo_install:
ifeq ($(_cargo_install),)
	$(error CARGO_HOME | CARGO_INSTALL_ROOT | $$HOME/.cargo is empty, cannot build/install!)
endif


$(HOME)/.terminfo:
	mkdir -p "$$HOME/.terminfo"


$(_bin): git-hash
	$(call log_info,compiling $@...)
	$(call check_pkgs,$(_depends))
	$(call check_binary,cmake pkg-config python3)
	@# BUG had issue where fontconfig.pc couldn't be found on the host
	PKG_CONFIG_PATH+=:$(_pkg_conf) \
	cargo +stable build \
		--manifest-path $(_src)/Cargo.toml \
		-j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 ))) \
		--release


$(HOME)/.bash_completion:
	mkdir -p $(HOME)/.bash_completion


$(_source_bash_comp): $(_bash_complete_script) | $(HOME)/.bash_completion
	cp $(_bash_complete_script) $(_source_bash_comp)


$(_cargo_bin): $(_bin)
	PKG_CONFIG_PATH+=:$(_pkg_conf) \
	cargo +stable install \
		--path $(_src)/alacritty \
		-j $(shell echo $$(( `nproc` <= 1 ? 1 : `nproc` -1 )))
