#!/usr/bin/make -f

# helper scripts to install dotfiles
# __file__ Makefile
#
# NB using phony recipes (not creating files) is an anti-pattern for Make
# but is used b/c it's cleaner than adding switches to a bash script


# FUTURE add dependency checker:  golang-go luarocks xsel git make cargo node

# TODO specify by path to binary: lua, during calls
#      b/c we can't depend on having ~/.local/bin in the PATH
# TODO move from using `which <program>` to using `command -v <program>` to test
#      if a binary exists
# TODO add something to test or ensure lua (or another binary) is in the path


SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
#MAKEFLAGS += --no-print-directory
PREFIX ?= $(HOME)/.local
# include call changes MAKEFILE_LIST, so capture this before include
MY_TARGETS := $(MAKEFILE_LIST)
SUB_PROJECTS := $(dir $(wildcard */Makefile))
# FUTURE gradually reducing required dependencies
# gcc: for compiling
# perl: for compiling
# curl: for downloading releases
# gpg: for verifying releases
# make: invoking the rules
DEPENDENCIES := ca-certificates gcc g++ gpg curl wget perl make git git-lfs vim screen lm-sensors libssl-dev unzip dconf-editor dconf-cli gir1.2-gtop-2.0 libx11-dev libxmu-dev rxvt-unicode
DEPENDENCIES_ZEPHYR := git ninja-build gperf ccache dfu-util device-tree-compiler wget python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1
# these packages will build but take a while
DEPENDENCIES_LONGRUN := clang cmake

# NG this 'imports' many of the Make functions used below
include ./helpers.mk

# OPTIONS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

# install configuration files for a target (e.g. bashrc, etc) if ON, else uninstall target
INSTALL_RC ?= ON
# set the host's nickname for bash prompt and tmux
HOST_ALIAS ?= $(HOSTNAME)
# if defined, copy configuration files to destination instead of linking to this repo's copies
NO_SYMLINKS ?=
export NO_SYMLINKS
# use this branch when compiling cpython
CPYTHON ?= 3.13


# FILEPATHS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

# TODO take user input for install dir, e.g. install to /data/.local/bin
# TODO add recipe to make install dir
# TODO use PREFIX instead of BIN_DIR and pass PREFIX to subsequent installers

BIN_DIR := $(PREFIX)/bin
BASHRC := $(HOME)/.bashrc
BASHPROFILE := $(HOME)/.bash_profile
HOST_ALIAS_RC := $(HOME)/.config/host_alias
INPUTRC := $(HOME)/.inputrc
TMUX_CONF := $(HOME)/.tmux.conf
VIMRC := $(HOME)/.vimrc
VUNDLE := $(HOME)/.vim/bundle/Vundle.vim
VUNDLE_URL=https://github.com/VundleVim/Vundle.vim.git
TPM := $(HOME)/.tmux/plugins/tpm
TPM_URL=https://github.com/tmux-plugins/tpm
FZF := $(HOME)/.fzf
FZF_URL := https://github.com/junegunn/fzf.git
ALACRITTY_CFG_DIR := $(HOME)/.config/alacritty
ALACRITTY_YML := $(ALACRITTY_CFG_DIR)/alacritty.yml
RXVT_CONF := $(HOME)/.Xresources
RXVT_CONF_D := $(HOME)/.Xresources.d
RC_CONF := $(HOME)/.config/ranger/rc.conf
FONTS := $(HOME)/.local/share/fonts
GOGH_THEMES_URL := https://github.com/Gogh-Co/Gogh.git
GOGH_THEMES := $(HOME)/Gogh
NVM := $(shell test -f "$(HOME)/.nvm/nvm.sh"; echo $$?)

CARGO_HOME := $(HOME)/.cargo
CARGO_BIN := $(HOME)/.cargo/bin
RIPGREP_BIN := $(CARGO_BIN)/rg
NINJA_BIN := $(BIN_DIR)/ninja

# export our bin dir so rules that require a target from a predecessor can execute it
export PATH := $(BIN_DIR):$(PATH)
export PREFIX := $(PREFIX)

# FUNCTONS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


# RECIPES \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.PHONY: help
help:                 ## usage
	@echo Usage:  make [RECIPE] [OPTIONS]
	@echo ""
	@echo "    recipes to configure dotfiles, tools, etc."
	@echo ""
	@echo "    OPTIONS:"
	@echo "        INSTALL_RC  (ON|OFF): un/install configuration/rc file (ON)"
	@echo "        NO_SYMLINKS     (ON): copy configuration files instead of linking to this project"
	@echo "        CPYTHON       ($(CPYTHON)): version of cpython to use"
	@echo ""
	@echo "    NOTE:"
	@echo "        configurations are installed using symlinks"
	@echo "        so the configurations will be removed if this repo is deleted;"
	@echo "        to opt out of this use NO_SYMLINMKS:=ON flag"
	@echo ""
	@grep -E '^[a-z_A-Z0-9^.(]+:.*?## .*$$' $(MY_TARGETS) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: all
all:                  ## install programs and configs
	$(MAKE) -ik check_packages
	$(MAKE) -ik m4
	$(MAKE) -ik autoconf
	$(MAKE) -ik automake
	$(MAKE) -ik libtool
	$(MAKE) -ik gettext
	$(MAKE) -ik make
	$(MAKE) -ik ctags
	$(MAKE) -ik tree
	$(MAKE) -ik pip
	$(MAKE) -ik pipx
	$(MAKE) -ik meson
	$(MAKE) -ik vim
	$(MAKE) -ik neovim
	$(MAKE) -ik tmux
	$(MAKE) -ik bash
	$(MAKE) -ik pv
	$(MAKE) -ik fio
	$(MAKE) -ik git_config
	$(MAKE) -ik virtualenvwrapper
	$(MAKE) -ik fzf
	$(MAKE) -ik rust
	$(MAKE) -ik alacritty  # includes fonts
	$(MAKE) -ik gnome
	$(MAKE) -ik cinnamon
	$(MAKE) -ik ranger
	$(MAKE) -ik rxvt.conf
	$(MAKE) -ik docker  # checks group membership, needs sudo
	$(MAKE) -ik tig
	$(MAKE) -ik check_packages


.PHONY: clean
clean:                ## clean all sub-projects
	$(call log_info,cleaning all sub projects...)
	@$(foreach sub,$(SUB_PROJECTS),echo -e "\e[32mINFO\tcleaning all sub projects... $(sub)\e[39m"; $(MAKE) -C $(sub) clean;)


.PHONY: download
download:             ## fetch | download all sub-project sources
	$(call log_info,downloading all sub projects...)
	@$(foreach sub,$(SUB_PROJECTS),echo -e "\e[32mINFO\tfetching all sub projects... $(sub)\e[39m"; $(MAKE) -C $(sub) download;)


.PHONY: gawk
gawk:                 ## GNU awk
	$(call log_info,updating $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: m4
m4: gawk              ## GNU M4 macro processor
	$(call log_info,updating $@...)
	$(MAKE) -k -C $@ all install


.PHONY: autoconf
autoconf:             ## M4 macros to configure sources (part of autotools-dev)
	$(call log_info,updating $@...)
	$(MAKE) -k -C $@ all install


.PHONY: automake
automake: gawk        ## generates Makefiles for use with autoconf (aclocal, automake) (part of autotools-dev)
	$(call log_info,updating $@...)
	$(MAKE) -k -C $@ all install


.PHONY: gettext
gettext:              ## tools to translate human languages (part of autotools-dev)
	$(call log_info,updating $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: libtool
libtool: gawk m4      ## makefile commands for handling shared libraries (part of autotools-dev)
	$(call log_info,updating $@...)
	$(MAKE) -k -C $@ all install


.PHONY: pkgconf
pkgconf: m4           ## handle include/lib paths for configure (replaces pgkf-config)
	$(call log_info,updating $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: pkg-config
pkg-config: m4           ## handle include/lib paths for configure
	$(call log_info,updating $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: libevent
libevent: cmake       ## callback library
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $@ all install


.PHONY: libncurses
libncurses: pkgconf   ## tui library
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $@ all install


.PHONY: ctags
ctags:                ## indexes source files
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $@ all install


.PHONY: fio
fio: libaio           ## flexible I/O benchmark utility
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $@ all install


.PHONY: libaio
libaio:               ## linux async I/O library
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $@ all install


.PHONY: sysbench
sysbench: make automake pkg-config libaio ## benchmarking utility
	$(call log_info,updating $@...)
	$(MAKE) -ik -C $@ all install


.PHONY: vim
vim:                  ## vim config and plugins
	$(call check_pkgs,"vim git")
	$(MAKE) -ik vimrc
	$(MAKE) -ik vim_plugins


.PHONY: vimrc
vimrc:                ## vim config
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/vimrc $(VIMRC)


.PHONY: vundle
vundle:               ## vim package manager
	$(call log_info,updating $@...)
	@#cloning vundle requires ca-certificates (apt) or manually adding the cert
	@#adding GIT_SSL_NO_VERIFY=1 doesn't seem to be a workaround
	$(call check_pkgs,ca-certificates)
	$(call git_clone_fetch_reset,$(VUNDLE_URL),$(VUNDLE))


# TODO install pipx first and use that instead of pip
# FUTURE consider parallel vundle installer?
# https://github.com/jdevera/parallel-vundle-installer
.PHONY: vim_plugins
vim_plugins: | vundle pip  ## download vim plugins
	$(call log_info,updating $@...)
	curl -kfLo $(HOME)/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	$(call log_info,updating $@... please wait while plugins are downloaded...)
	vim +'PluginInstall' +qall +'--sync' &>/dev/null
	pip install --user grip  # for 'JamshedVesuna/vim-markdown-preview'


.PHONY: tmux
tmux: | m4 autoconf automake pkgconf libtool bison cmake libevent xsel xclip  ## add tmux config and plugins
	$(call log_info,updating $@...)
	$(call check_pkgs,screen)
	$(MAKE) -ik -C ./tmux

	$(call log_info,updating tmux plugins...)
	$(MAKE) -ik tpm
	$(MAKE) -ik tmux.conf
	@# TODO you have to have tmux in the path to call tmux plugins
	$(MAKE) -ik tmux_plugins


.PHONY: tmux.conf
tmux.conf:            ## add tmux config file
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/tmux.conf $(TMUX_CONF)


.PHONY: tmux_plugins
tmux_plugins: | pip   ## download tmux plugins
	$(call log_info,updating $@...)
	-@LD_LIBRARY_PATH+=:$(PREFIX)/lib $(HOME)/.tmux/plugins/tpm/scripts/install_plugins.sh
	-@LD_LIBRARY_PATH+=:$(PREFIX)/lib $(HOME)/.tmux/plugins/tpm/scripts/update_plugin.sh
	pip install --user psutil  # for tmux cpu info


.PHONY: tpm
tpm:                  ## tmux plugin manager
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(TPM_URL),$(TPM))


.PHONY: bash
bash:                 ## bash: bashrc, inputrc, bashrprofile, functions, aliases
	$(MAKE) -ik inputrc
	$(MAKE) -ik bashrc
	$(MAKE) -ik bashprofile
	$(MAKE) -ik functions
	$(MAKE) -ik aliases


.PHONY: inputrc
inputrc:              ## add command line config
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/inputrc $(INPUTRC)


$(BASHRC):
	touch $(BASHRC)


.PHONY: bashrc
bashrc: | $(BASHRC)   ## login shell config
	$(call log_info,updating $@...)
	@sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' $(BASHRC)
	@mkdir -p ~/.config
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/bashrc ~/.config/bashrc
	$(call source_file,$(BASHRC),CUSTOM_BASHRC,~/.config/bashrc)
	$(call comment_line,$(BASHRC),CUSTOM_BASHRC,$(INSTALL_RC))


.PHONY: bashprofile
bashprofile:          ## non-login shell config
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/bash_profile ~/.config/bash_profile
	$(call source_file,$(BASHPROFILE),CUSTOM_BASHPROFILE,~/.config/bash_profile)
	$(call comment_line,$(BASHPROFILE),CUSTOM_BASHPROFILE,$(INSTALL_RC))


.PHONY: pv
pv: make
	$(call log_info,updating $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: alacritty.yml
alacritty.yml:        ## configuration for alacritty terminal
	$(call log_info,updating $@...)
	@mkdir -p $(ALACRITTY_CFG_DIR)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/assets/alacritty $(ALACRITTY_CFG_DIR)
	@mkdir -p $(BIN_DIR)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/fullscreen $(BIN_DIR)/fullscreen


.PHONY: alacritty
alacritty: rust       ## compile alacritty terminal
	$(call log_info,updating $@...)
	$(MAKE) -ik -C alacritty all install
	$(MAKE) -ik alacritty.yml
	$(MAKE) -ik fonts
	$(call check_pkgs,wmctrl xdotool)


# TODO install pip w/o apt (python3-pip)
.PHONY: virtualenvwrapper
virtualenvwrapper: pip   ## python virtual environments (virtualenvwrapper)
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/python_venv ~/.config/python_venv
	-bash -c "python3 -m pip install --user -UI setuptools pip virtualenv virtualenvwrapper"
	$(call source_file,$(BASHRC),CUSTOM_PYTHON,~/.config/python_venv)
	$(call comment_line,$(BASHRC),CUSTOM_PYTHON,$(INSTALL_RC))


.PHONY: conda
conda:                ## miniconda python distribution & package manager
	@$(ROOT_DIR)/install_miniconda.sh


.PHONY: ranger
ranger: pipx              ## ranger configuration
	$(call log_info,updating $@...)
	pipx install ranger-fm
	@# NOTE installing ranger via pipx b/c the Makefile for ranger doesn't allow specifying PREFIX
	@# b/c it appends `local` to whatever PREFIX you use (so $HOME/.local becomes $HOME/.local/local)
	ranger --copy-config=all
	-sed -i 's/set\ preview_images\ false/set\ preview_images\ true/' $(RC_CONF)
	-sed -i 's/set\ preview_images_method\ .*/set\ preview_images_method\ w3m/' $(RC_CONF)


.PHONY: rxvt.conf
rxvt.conf: xsel            ## rxvt configuration
	$(call log_info,updating $@...)
	$(call check_pkgs,rxvt-unicode,libxext-dev,xsel,libx11-dev)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/assets/Xresources $(RXVT_CONF)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/assets/Xresources.d $(RXVT_CONF_D)
	xrdb -merge $(RXVT_CONF)


# TODO remove in favor of backing up on a per target basis, and using update_symlink.bash to backup
# NB -u: update if newer, --backup=t: number the backups
.PHONY: backup
backup:               ## backup dotfiles
	-cp -u --backup=t $(VIMRC){,~}
	-cp -u --backup=t $(BASHRC){,~}
	-cp -u --backup=t $(INPUTRC){,~}
	-cp -u --backup=t $(TMUX_CONF){,~}
	-cp -u --backup=t $(ALACRITTY_YML){,~}
	-cp -u --backup=t $(RC_CONF){,~}
	-cp -u --backup=t $(RXVT_CONF){,~}


.PHONY: functions
functions:            ## bash helper functions
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/bash-functions ~/.config/functions
	@$(call source_file,$(BASHRC),CUSTOM_FUNCTIONS,~/.config/functions)
	@$(call comment_line,$(BASHRC),CUSTOM_FUNCTIONS,$(INSTALL_RC))


.PHONY: aliases
aliases:              ## bash aliases
	$(call log_info,updating $@...)
	@# Ubuntu sourcs ~/.bash_aliases by default
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/bash_aliases ~/.bash_aliases


.PHONY: fzf
fzf:                  ## command-line fuzzy finder
	$(call log_info,updating $@...)
	$(call git_clone_fetch_reset,$(FZF_URL),$(FZF))
	$(FZF)/install --all


.PHONY: cinnamon
cinnamon:             ## cinnamon desktop
	$(call log_info,updating $@...)

	@# default file explorer as nautilus, not nemo
	sed -i "s%/inode/directory=.*%/inode/directory=org.gnome.Nautilus.desktop%" ~/.config/mimeapps.list

	@# wallpapers
	gsettings set org.cinnamon.desktop.background.slideshow image-source "directory://$(ROOT_DIR)/assets/wallpapers"
	gsettings set org.cinnamon.desktop.background.slideshow slideshow-enabled true

	@# theme
	gsettings set org.cinnamon.desktop.interface icon-theme "Yaru"
	gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita-dark"

	@# panel
	gsettings set org.cinnamon enabled-applets "['panel1:left:0:menu@cinnamon.org:0', 'panel1:right:5:systray@cinnamon.org:3', 'panel1:right:6:xapp-status@cinnamon.org:4', 'panel1:right:7:notifications@cinnamon.org:5', 'panel1:right:8:network@cinnamon.org:10', 'panel1:right:9:sound@cinnamon.org:11', 'panel1:right:10:calendar@cinnamon.org:13', 'panel1:left:3:window-list@cinnamon.org:14', 'panel1:right:0:temperature@fevimu:15', 'panel1:right:2:multicore-sys-monitor@ccadeptic23:16', 'panel1:right:3:sysmonitor@orcus:17', 'panel1:right:1:workspace-grid@hernejj:18']"
	gsettings set org.cinnamon panels-height "['1:32']"

	@# improve performance for full screen GUIs
	gsettings set org.cinnamon.muffin unredirect-fullscreen-windows true
	gsettings set org.cinnamon.muffin desktop-effects false

	@# don't create clicks that aren't actually pressed!
	gsettings set org.cinnamon.settings-daemon.peripherals.mouse middle-button-enabled false


.PHONY: gnome
gnome:                ## gnome desktop
	$(call log_info,updating $@...)
	bash -i $(ROOT_DIR)/kb_shortcuts_gnome.bash

	# NOTE testing on 18.04
	gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
	# switch windows instead of applications w/ alt-tab
	gsettings set org.gnome.desktop.wm.keybindings switch-applications "[]"
	gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "[]"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab', '<Super>Tab']"
	gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Alt><Shift>Tab', '<Super><Shift>Tab']"
	# change windows aross all workspaces
	#gsettings set org.gnome.shell.window-switcher current-workspace-only true
	gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
	gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
	# scrolling direction (false = drag up to view content above)
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
	# gedit
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true
	gsettings set org.gnome.gedit.preferences.editor tabs-size 4
	gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'

	# don't create clicks that aren't actually pressed
	gsettings set org.gnome.desktop.peripherals.mouse middle-click-emulation false

	$(call git_clone_fetch_reset,$(GOGH_THEMES_URL),$(GOGH_THEMES))
	TERMINAL=gnome-terminal $(GOGH_THEMES)/installs/dark-pastel.sh

	@$(ROOT_DIR)/install_wintile.bash


.PHONY: git_config
git_config:           ## sensible git (install LFS, add credential helper)
	$(call log_info,updating $@...)
	$(call check_pkgs,git)
	@# just need to call once after installing `git-lfs` from apt
	git lfs install || echo -e "\e[91mERROR\t git lfs init failed, git LFS is not installed! \e[39m"
	git config --global credential.helper store  # we use oath tokens, so it needs to persist
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/tigrc $(HOME)/.tigrc


.PHONY: host_alias
host_alias:           ## set the nickname for this machine
	$(call log_info,updating $@...)
	@mkdir -p `dirname $(HOST_ALIAS_RC)`
	@echo $(HOST_ALIAS) > $(HOST_ALIAS_RC)


.PHONY: zathura
zathura:             ## zathura pdf reader config
	$(call log_info,updating $@...)
	$(call check_pkgs,zathura)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/assets/zathura ~/.config/zathura


.PHONY: lua
lua:                 ## install Lua
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: luajit
luajit:              ## install LuaJIT
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: luarocks
luarocks: lua        ## install luarocks package manager
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: neovim
neovim: | lua luajit luarocks rust rg npm cmake gettext ninja  ## install neovim
	$(call log_info,updating $@...)
	@# neovim requires lua 5.1 (preferably luajit)
	@# some lsp's require node
	@# cargo install tree-sitter-cli, for the lsp's, b/c it's more reliable than npm
	$(call log_info,compiling tree sitter...)
	$(CARGO_BIN)/cargo install tree-sitter-cli
	$(call log_info,compiling neovim...)
	$(MAKE) -ik -C neovim all install
	$(MAKE) -ik nvimrc


.PHONY: nvimrc
nvimrc:              ## neovim config and plugins
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/update_symlink.bash $(ROOT_DIR)/assets/nvim $(HOME)/.config/nvim

	$(call log_info,updating lazy...)
	nvim --headless "+Lazy! sync" +qa

	$(call log_info,updating mason...)
	nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'


.PHONY: fonts
fonts:               ## install fonts
	@# TODO make this a function
	curl -o /tmp/UbuntuMono.zip -L -O -C - https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/UbuntuMono.zip
	mkdir -p $(FONTS)/UbuntuMono
	unzip -u /tmp/UbuntuMono.zip -d $(FONTS)/UbuntuMono

	curl -o /tmp/DejaVuSansMono.zip -L -O -C - https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/DejaVuSansMono.zip
	mkdir -p $(FONTS)/DejaVuSansMono
	unzip -u /tmp/DejaVuSansMono.zip -d $(FONTS)/DejaVuSansMono

	fc-cache -f


.PHONY: check_packages
check_packages:         ## warn if missing packages
	$(call log_info,$@...)
	@bash -l -c 'source $(ROOT_DIR)/helpers.bash && are_packages_missing $(DEPENDENCIES)'
	@bash -l -c 'source $(ROOT_DIR)/helpers.bash && are_packages_missing $(DEPENDENCIES_NVIM)'
	@bash -l -c 'source $(ROOT_DIR)/helpers.bash && are_packages_missing_warn $(DEPENDENCIES_LONGRUN)'


.PHONY: pip
pip:                    ## install pip
	$(call log_info,checking for $@...)
	@#NOTE `ensurepip` is disabled in ubuntu so use get-pip
	@which pip || { wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py --user; }


.PHONY: cpython
cpython:  pkgconf       ## compile cpython
	$(call log_info,compiling $@...)
	$(MAKE) _branch=$(CPYTHON) -k -C $@ all install


# TODO needs curl
.PHONY: rust
rust:                   ## install rust compiler
	$(call log_info,installing $@...)
	@$(ROOT_DIR)/install_rust.sh


.PHONY: rg
rg: $(RIPGREP_BIN)


.PHONY: $(RIPGREP_BIN)  # phony b/c cargo manages the version
$(RIPGREP_BIN): | rust
	$(call log_info,installing $@...)
	which rustc || . $(CARGO_HOME)/env && cargo install ripgrep


.PHONY: node_version_manager
node_version_manager:   ## install Node Version Manager
	$(call log_info,installing $@...)
ifneq ($(shell test -f "$(HOME)/.nvm/nvm.sh"; echo $$?),0)
	@# (see https://github.com/nvm-sh/nvm)
	@# uninstall via `rm -rf ~/.nvm`
	@bash -l -c 'source ~/.bashrc && type -t nvm || \
		{ wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash; exit 0; }'
else
	@echo "nvm is already installed"
endif


.PHONY: npm
npm: node_version_manager ## install nvm and Node
	$(call log_info,installing $@...)
	@# uninstall via `rm -rf ~/.nvm`
	@# MAGIC 24, specifying `nvm install 24` b/c some treesitter parsers need a recent version of node (e.g. latex)
	@# you may need to uninstall old versions, e.g. `nvm uninstall 20`
	@bash -l -c 'unset PREFIX; source ~/.bashrc && type -t npm 2>&1 >/dev/null && \
		{ echo "node is already installed"; } || \
		{ source ~/.nvm/nvm.sh && nvm install 24; exit 0; }'


.PHONY: mdpdf
mdpdf: npm               ## install Markdown to PDF converter
	$(call log_info,installing $@...)
	@# see https://github.com/BlueHatbRit/mdpdf
	@bash -l -c 'unset PREFIX; source ~/.bashrc && type -t mdpdf 2>&1 >/dev/null && \
		{ echo "mdpdf is already installed"; } || \
		{ source ~/.nvm/nvm.sh && npm install mdpdf -g; exit 0; }'


.PHONY: make
make:                    ## install make
	$(call log_info,installing $@...)
	$(MAKE) -k -C $@ all install


# TODO pipx needs pip first
# TODO need to use $(BIN_DIR)/pipx
.PHONY: pipx
pipx:                    ## install pip extension 'pipx'
	$(call log_info,updating $@...)
	pip install --user --upgrade pipx
	pipx ensurepath
	pipx completions
	grep -q "eval.*argcomplete pipx)" $(BASHRC) || echo 'eval "$(register-python-argcomplete pipx)"' >> $(BASHRC)


.PHONY: meson
meson: | pipx            ## install meson
	$(call log_info,updating $@...)
	pipx install meson


.PHONY: zephyr
zephyr: | ninja          ## zephyr RTOS SDK
	$(call log_info,installing $@...)
	@$(ROOT_DIR)/install_zephyr.bash


.PHONY: docker
docker:                  ## enable docker w/o sudo
	$(call log_info,setup $@...)
	./setup_docker.bash


.PHONY: image
image:                   ## docker image for testing
	$(call log_info,testing dotfiles with docker image...)
	docker build \
		-f Dockerfile \
		--progress=plain \
		--target test \
		--tag dotfiles \
		.


.PHONY: container
container:               ## run docker image for testing interactively
	$(call log_info,building intermediate image w/ apt dependencies...)
	docker build \
		-f Dockerfile \
		--progress=plain \
		--target base \
		--tag dotfiles-test \
		.
	$(call log_info,running container interactively for testing...)
	docker run -it --rm \
		-e TZ=$(cat /etc/timezone) \
		dotfiles-test


.PHONY: cmake
cmake:                  ## compile CMake
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: ninja
ninja: cmake          ## compile ninja-build
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: bison
bison: gawk gettext   ## compile bison
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: htop
htop: autoconf automake gettext libtool  ## compile htop
	@# TODO compiling libncurses and using /usr/bin/htop may result
	@# in a 'no version info available' b/c of a version mismatch (?)
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: tig
tig:                  ## compile tig
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: xsel
xsel: pkgconf autoconf automake libtool m4  ## compile xsel
	$(call log_info,installing $@...)
	@# TODO xsel requires x11 library
	@# see https://www.linuxfromscratch.org/blfs/view/svn/x/x7lib.html
	$(call make_all_install_if_not_on_host,$@)


.PHONY: xclip
xclip: pkgconf autoconf automake libtool m4  ## compile xclip
	$(call log_info,installing $@...)
	@# TODO xclip requires x11 library
	@# see https://www.linuxfromscratch.org/blfs/view/svn/x/x7lib.html
	$(call make_all_install_if_not_on_host,$@)


.PHONY: tree
tree:                 ## compile tree
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: clang
clang: cmake ninja    ## compile clang via LLVM
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: odin
odin: cmake ninja    ## compile ODIN lang
	$(call log_info,installing $@...)
	$(MAKE) -k -C $@ all install


.PHONY: latex
latex:               ## install LaTeX
	$(call log_info,installing $@...)
	$(MAKE) -k -C $@ all install


.PHONY: curl
curl: autoconf automake libtool  ## install curl
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: git
git:                 ## git
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: zig
zig: export _branch=release/19.x
zig: clang ## install curl
	$(call log_info,installing $@...)
	$(call make_all_install_if_not_on_host,$@)


.PHONY: readline
readline: m4         ## readline
	$(call log_info,installing $@...)
	$(MAKE) -k -C $@ all install
