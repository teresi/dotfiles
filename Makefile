#!/usr/bin/make -f

# helper scripts to install dotfiles
# __file__ Makefile
#
# NB using phony recipes (not creating files) is an anti-pattern for Make
# but is used b/c it's cleaner than adding switches to a bash script


SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFLAGS += --no-print-directory


# OPTIONS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

# install configuration files for a target (e.g. bashrc, etc) if ON, else uninstall target
INSTALL_RC ?= ON
# set the host's nickname for bash prompt and tmux
HOST_ALIAS ?= COMPY
# use symlinks for config files, else copy files to destination
USE_SYMLINKS ?= ON

# FILEPATHS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

# TODO take user input for install dir, e.g. install to /data/.local/bin
# TODO add recipe to make install dir
INSTALL_DIR := $(HOME)/.local/bin
BASHRC := $(HOME)/.bashrc
BASHPROFILE := $(HOME)/.bash_profile
HOST_ALIAS_RC := $(HOME)/.config/host_alias
INPUTRC := $(HOME)/.inputrc
TMUX_CONF := $(HOME)/.tmux.conf
VIMRC := $(HOME)/.vimrc
VUNDLE := $(HOME)/.vim/bundle/Vundle.vim
#VUNDLE_URL=https://github.com/VundleVim/Vundle.vim.git
VUNDLE_URL=https://github.com/teresi/Vundle.vim.git  # temporary fix for when the original is 404
TPM := $(HOME)/.tmux/plugins/tpm
TPM_URL=https://github.com/tmux-plugins/tpm
FZF := $(HOME)/.fzf
FZF_URL := https://github.com/junegunn/fzf.git
ALACRITTY_CFG_DIR := $(HOME)/.config/alacritty
ALACRITTY_YML := $(ALACRITTY_CFG_DIR)/alacritty.yml
RXVT_CONF := $(HOME)/.Xresources
RC_CONF := $(HOME)/.config/ranger/rc.conf
NVIM := $(HOME)/neovim
NVIM_URL := https://github.com/neovim/neovim.git


# FUNCTONS \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

define log_info
	@echo -e "\e[32mINFO\t$1\e[39m"
endef

define log_warn
	@echo -e "\e[33mWARN\t$1\e[39m"
endef

define log_error
	@echo -e "\e[91mERROR\t$1\e[39m"
endef

# git clone (if not exist)
#	1    git url
#	2    directory
define git_clone
	@if [ ! -d $(2) ]; then git clone $(1) $(2); fi;
endef

# git pull
#	Fetch and reset to origin/master
#	1    directory
define git_master
	@git -C $(1) fetch && git -C $(1) checkout master && git -C $(1) reset --hard origin/master
endef

# clone or fetch/merge master
#	1    git url
#	2    directory
define update_repo
	$(call log_info,updating $(1) -> $(2))
	$(call git_clone,$(1), $(2))
	$(call git_master,$(2))
endef

# update a file at $2 with contents of $1
#	Copy if source is newer or the files differ, so repeated backup calls don't create duplicates
#	1    source
#	2    destination
define update_file
	@if [ $(1) -nt $(2) ]; then cp $(1) $(2); else cmp --silent $(1) $(2) || cp $(1) $(2); fi
endef

# add symlink at $2 pointing to target $1
#      Backup file at $1 if exists and is not a symlink
#      1    target of symlink
#      2    linkname of symlink
define update_link
	@if [ ! -L $(2) ] && [ -f $(2) ]; then cp -fu --backup=t $(2){,~}; fi
	@if [ "$(USE_SYMLINKS)" == "ON" ]; then ln -sfn $(1) $(2); else cp $(1) $(2); fi
endef

# uncomment a line in a file given a pattern if flag is ON, comment out else
#	1   filepath
#	2   pattern
#	3   flag (ON|OFF)
define comment_line
	@if [ "$3" == "ON" ]; then sed -i '/$(2)/s/^#*\s*//g' $(1); else sed -i '/$(2)/s/^#*/#/g' $(1); fi
endef

# append a 'source $3' call to a file $1
#      Appends the line if it does *not* exist
#      Uses the magic keyword as a comment (# delimited) to test if the call exists
#      1    filepath to append to
#      2    magic keyword
#      3    filepath to source
define source_file
	grep -q $(2) $(1) || echo "[ -r $(3) ] && source $(3)  # $(2)" >> $(1)
endef


# RECIPES \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.PHONY: help
help:                 ## usage
	@echo Usage:  make [RECIPE] [OPTIONS]
	@echo ""
	@echo "    recipes to configure dotfiles, tools, etc."
	@echo ""
	@echo "    OPTIONS:"
	@echo "        INSTALL_RC   (ON|OFF): un/install configuration/rc file (ON)"
	@echo "        USE_SYMLINKS (ON|OFF): use symlinks for configs, else copy (ON)"
	@echo ""
	@echo "    NOTE:"
	@echo "        configurations are installed using symlinks"
	@echo "        so the configurations will be removed if this repo is deleted;"
	@echo "        to opt out of this use USE_SYMLINMKS:=off flag"
	@echo ""
	@grep -E '^[a-z_A-Z0-9^.(]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# NB not installing alacritty here b/c it's not used on remote logins
.PHONY: all
all: | config         ## install programs and configs
	$(MAKE) -ik vim_plugins
	$(MAKE) -ik tmux_plugins
	$(MAKE) -ik virtualenvwrapper
	$(MAKE) -ik fzf
	$(MAKE) -ik gnome
	$(MAKE) -ik cinnamon


.PHONY: config
config:               ## install configs
	$(MAKE) -ik vimrc
	$(MAKE) -ik bashrc
	$(MAKE) -ik aliases
	$(MAKE) -ik bashprofile
	$(MAKE) -ik inputrc
	$(MAKE) -ik tmux.conf
	$(MAKE) -ik ranger
	$(MAKE) -ik alacritty.yml
	$(MAKE) -ik functions
	$(MAKE) -ik git_config
	$(MAKE) -ik python_packages
	$(MAKE) -ik rxvt.conf


.PHONY: depends
depends:              ## install system dependencies
	$(ROOT_DIR)/install_dependencies.sh


.PHONY: vim
vim:                  ## vim config and plugins
	$(MAKE) -ik vimrc
	$(MAKE) -ik vim_plugins


.PHONY: vimrc
vimrc:                ## vim config
	$(call log_info,updating $@...)
	$(call update_link,$(ROOT_DIR)/vimrc,$(VIMRC))


.PHONY: vundle
vundle:               ## vim package manager
	$(call log_info,updating $@...)
	$(call update_repo,$(VUNDLE_URL),$(VUNDLE))


.PHONY: vim_plugins
vim_plugins: | vundle ## download vim plugins
	$(call log_info,updating $@...)
	vim --noplugin +PluginInstall +qall


.PHONY: tmux
tmux:                 ## add tmux config and plugins
	$(MAKE) -ik tmux.conf
	$(MAKE) -ik tmux_plugins


.PHONY: tmux.conf
tmux.conf:            ## add tmux config file
	$(call log_info,updating $@...)
	$(call update_link,$(ROOT_DIR)/tmux.conf,$(TMUX_CONF))


.PHONY: tmux_plugins
tmux_plugins: | tpm   ## download tmux plugins
	$(call log_info,updating $@...)
	-@$(HOME)/.tmux/plugins/tpm/scripts/install_plugins.sh


.PHONY: tpm
tpm:                  ## tmux plugin manager
	$(call log_info,updating $@...)
	$(call update_repo,$(TPM_URL),$(TPM))


.PHONY: inputrc
inputrc:              ## add command line config
	$(call log_info,updating $@...)
	$(call update_link,$(ROOT_DIR)/inputrc,$(INPUTRC))


.PHONY: bashrc
bashrc:               ## login shell config
	$(call log_info,updating $@...)
	@sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' $(BASHRC)
	$(call update_link,$(ROOT_DIR)/bashrc,~/.config/bashrc)
	$(call source_file,$(BASHRC),CUSTOM_BASHRC,~/.config/bashrc)
	$(call comment_line,$(BASHRC),CUSTOM_BASHRC,$(INSTALL_RC))


.PHONY: bashprofile
bashprofile:          ## non-login shell config
	$(call log_info,updating $@...)
	$(call update_link,$(ROOT_DIR)/bash_profile,~/.config/bash_profile)
	$(call source_file,$(BASHPROFILE),CUSTOM_BASHPROFILE,~/.config/bash_profile)
	$(call comment_line,$(BASHPROFILE),CUSTOM_BASHPROFILE,$(INSTALL_RC))


.PHONY: alacritty.yml
alacritty.yml: | $(ALACRITTY_CFG_DIR)  ## configuration for alacritty terminal
	$(call log_info,updating $@...)
	$(call update_link,$(ROOT_DIR)/alacritty.yml,$(ALACRITTY_YML))


$(ALACRITTY_CFG_DIR):
	mkdir -p $(ALACRITTY_CFG_DIR)


.PHONY: alacritty
alacritty:            ## compile alacritty terminal
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/install_alacritty.sh || echo -e "\e[91mERROR\t install failed; remember to close all Alacritty instances first \e[39m"


.PHONY: virtualenvwrapper
virtualenvwrapper:    ## python virtual environments (virtualenvwrapper)
	$(call log_info,updating $@...)
	$(call update_link,$(ROOT_DIR)/python_venv,~/.config/python_venv)
	$(call source_file,$(BASHRC),CUSTOM_PYTHON,~/.config/python_venv)
	$(call comment_line,$(BASHRC),CUSTOM_PYTHON,$(INSTALL_RC))
	-bash -c "python3 -m pip install --user virtualenvwrapper"


.PHONY: conda
conda:                ## miniconda python distribution & package manager
	@$(ROOT_DIR)/install_miniconda.sh


.PHONY: ranger
ranger:               ## ranger configuration
	$(call log_info,updating $@...)
	ranger --copy-config=all || echo -e "\e[91mERROR\t ranger config failed, ranger is not installed! \e[39m"
	-sed -i 's/set\ preview_images\ false/set\ preview_images\ true/' $(RC_CONF)
	-sed -i 's/set\ preview_images_method\ w3m/set\ preview_images_method\ urxvt/' $(RC_CONF)


.PHONY: rxvt.conf
rxvt.conf:            ## rxvt configuration
	$(call log_info,updating $@...)
	@# needs apt packages: rxvt-unicode xsel
	$(call update_link,$(ROOT_DIR)/Xresources,$(RXVT_CONF))
	xrdb -merge $(RXVT_CONF)


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
	$(call update_link,$(ROOT_DIR)/bash-functions,~/.config/functions)
	@$(call source_file,$(BASHRC),CUSTOM_FUNCTIONS,~/.config/functions)
	@$(call comment_line,$(BASHRC),CUSTOM_FUNCTIONS,$(INSTALL_RC))


.PHONY: aliases
aliases:              ## bash aliases
	$(call log_info,updating $@...)
	@# Ubuntu sourcs ~/.bash_aliases by default
	$(call update_link,$(ROOT_DIR)/bash_aliases,~/.bash_aliases)


.PHONY: fzf
fzf:                  ## command-line fuzzy finder
	$(call log_info,updating $@...)
	$(call update_repo,$(FZF_URL),$(FZF))
	$(FZF)/install --all


.PHONY: python_packages
python_packages:      ## extra python package dependencies
	$(call log_info,updating $@...)
	python3 -m pip install --user grip                # for 'JamshedVesuna/vim-markdown-preview' 


.PHONY: cinnamon
cinnamon:             ## cinnamon desktop
	$(call log_info,updating $@...)
	bash -i $(ROOT_DIR)/kb_shortcuts_cinnamon.bash
	gsettings set org.cinnamon.desktop.background.slideshow image-source "directory://$(ROOT_DIR)/wallpapers"
	gsettings set org.cinnamon.desktop.background.slideshow slideshow-enabled true
	# theme
	# TODO find out how to download themes automatically to change window borders (wm/preferences)
	gsettings set org.cinnamon.desktop.interface icon-theme "Yaru"
	gsettings set org.cinnamon.desktop.interface gtk-theme "Adwaita-dark"
	# panel
	gsettings set org.cinnamon enabled-applets "['panel1:left:0:menu@cinnamon.org:0', 'panel1:right:5:systray@cinnamon.org:3', 'panel1:right:6:xapp-status@cinnamon.org:4', 'panel1:right:7:notifications@cinnamon.org:5', 'panel1:right:8:network@cinnamon.org:10', 'panel1:right:9:sound@cinnamon.org:11', 'panel1:right:10:calendar@cinnamon.org:13', 'panel1:left:3:window-list@cinnamon.org:14', 'panel1:right:0:temperature@fevimu:15', 'panel1:right:2:multicore-sys-monitor@ccadeptic23:16', 'panel1:right:3:sysmonitor@orcus:17', 'panel1:right:1:workspace-grid@hernejj:18']"
	gsettings set org.cinnamon panels-height "['1:32']"


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


.PHONY: git_config
git_config:           ## sensible git (install LFS, add credential helper)
	$(call log_info,updating $@...)
	@# just need to call once after installing `git-lfs` from apt
	git lfs install || echo -e "\e[91mERROR\t git lfs init failed, git LFS is not installed! \e[39m"
	git config --global credential.helper cache  # cache user/pass for 15 minutes


.PHONY: host_alias
host_alias:           ## set the nickname for this machine
	$(call log_info,updating $@...)
	@mkdir -p `dirname $(HOST_ALIAS_RC)`
	@echo $(HOST_ALIAS) > $(HOST_ALIAS_RC)


.PHONY: zathura
zathura:             ## zathura pdf reader config
	$(call log_info,updating $@...)
	$(call update_link,$(ROOT_DIR)/zathura,~/.config/zathura)


.PHONY: neovim
neovim:              ## neovim
	$(call log_info,updating $@...)
	$(call update_repo,$(NVIM_URL),$(NVIM))
	@# TODO check for dependencies:  ninja-build gettext libtool-bin cmake g++ pkg-config unzip curl
	rm -rf $(NVIM)/build
	make -C $(NVIM) CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$(INSTALL_DIR)"
	make -C $(NVIM) install
