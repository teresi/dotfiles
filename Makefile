# helper scripts to install dotfiles
# __file__ Makefile
#
# NB using phony recipes (not creating files) is an anti-pattern for Make
# but is used b/c it's cleaner than adding switches to a bash script

# TODO use gnu-stow instead of cp commands for installing configs

SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
MAKEFLAGS += --no-print-directory

# URIs
BASHRC := $(HOME)/.bashrc
BASHPROFILE := $(HOME)/.bash_profile
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
RC_CONF := $(HOME)/.config/ranger/rc.conf


# functions
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
#	Prevent merge by using fetch / checkout / reset
#	1    directory
define git_pull
	@git -C $(1) fetch && git -C $(1) checkout master && git -C $(1) reset --hard origin/master
endef

# clone or pull master
#	1    git url
#	2    directory
define update_repo
	$(call log_info,updating $(1) -> $(2))
	$(call git_clone,$(1), $(2))
	$(call git_pull,$(2))
endef

# update a file
#	Copy if source is newer or the files differ, so repeated backup calls don't create duplicates
#	1    source
#	2    destination
define update_file
	@if [ $(1) -nt $(2) ]; then cp $(1) $(2); else cmp --silent $(1) $(2) || cp $(1) $(2); fi
endef


.PHONY: help
help:                 ## usage
	@echo Usage:  make [RECIPE]
	@echo "    recipes to configure dotfiles, tools, etc."
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


# NB not installing alacritty here b/c it's not used on remote logins
.PHONY: all
all: | config         ## install programs and configs
	$(MAKE) -ik vundle
	$(MAKE) -ik vim_plugins
	$(MAKE) -ik tpm
	$(MAKE) -ik virtualenvwrapper
	$(MAKE) -ik fzf


.PHONY: config
config: | backup     ## install configs
	$(MAKE) -ik vimrc
	$(MAKE) -ik bashrc
	$(MAKE) -ik bashprofile
	$(MAKE) -ik inputrc
	$(MAKE) -ik tmux.conf
	$(MAKE) -ik rc.conf
	$(MAKE) -ik alacritty.yml
	$(MAKE) -ik functions
	$(MAKE) -ik git_config
	$(MAKE) -ik python_packages
	$(MAKE) -ik rxvt.conf


.PHONY: depends
depends:              ## system dependencies
	$(ROOT_DIR)/install_dependencies.sh


.PHONY: vimrc
vimrc:                ## vim config
	$(call log_info,updating $@...)
	$(call update_file,$(ROOT_DIR)/vimrc,$(VIMRC))


.PHONY: vundle
vundle:               ## vim package manager
	$(call log_info,updating $@...)
	$(call update_repo,$(VUNDLE_URL),$(VUNDLE))


.PHONY: tpm
tpm:                  ## tmux plugin manager
	$(call log_info,updating $@...)
	$(call update_repo,$(TPM_URL),$(TPM))


.PHONY: vim_plugins
vim_plugins:          ## download vim plugins
	$(call log_info,updating $@...)
	vim --noplugin +PluginInstall +qall


.PHONY: inputrc
inputrc:              ## command line config
	$(call log_info,updating $@...)
	$(call update_file,$(ROOT_DIR)/inputrc,$(INPUTRC))


.PHONY: tmux.conf
tmux.conf:            ## tmux config
	$(call log_info,updating $@...)
	$(call update_file,$(ROOT_DIR)/tmux.conf,$(TMUX_CONF))


# TODO use an include rather than copying block of text into the bashrc
.PHONY: bashrc
bashrc:               ## login shell config
	$(call log_info,updating $@...)
	sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' $(BASHRC)
	sed -i 's/HISTSIZE=1000/HISTSIZE=16384/' $(BASHRC)
	sed -i 's/HISTFILESIZE=2000\n/HISTFILESIZE=65536/' $(BASHRC)
	# replace block of text between markers
	grep -q -F '#BASH_CUSTOMIZATIONS_START' $(BASHRC) || \
		printf '\n#BASH_CUSTOMIZATIONS_START\n#BASH_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#BASH_CUSTOMIZATIONS_START.*?#BASH_CUSTOMIZATIONS_END/`cat bash-customizations`/se' $(BASHRC)


.PHONY: bashprofile
bashprofile:          ## non-login shell config
	$(call log_info,updating $@...)
	grep -q -F '#BASH_PROFILE_CUSTOMIZATIONS_START' $(BASHPROFILE) || \
		printf '\n#BASH_PROFILE_CUSTOMIZATIONS_START\n#BASH_PROFILE_CUSTOMIZATIONS_END' >> $(BASHPROFILE)
	perl -i -p0e 's/#BASH_PROFILE_CUSTOMIZATIONS_START.*?#BASH_PROFILE_CUSTOMIZATIONS_END/`cat bash-profile-customizations`/se' $(BASHPROFILE)


.PHONY: alacritty.yml ## alacritty terminal config
alacritty.yml: | $(ALACRITTY_CFG_DIR)  ## configuration for alacritty terminal
	$(call log_info,updating $@...)
	cp  -u $(ROOT_DIR)/alacritty.yml $(ALACRITTY_YML)


$(ALACRITTY_CFG_DIR): ## alacritty config directory
	mkdir -p $(ALACRITTY_CFG_DIR)


.PHONY: alacritty
alacritty:            ## compile alacritty terminal
	$(call log_info,updating $@...)
	@$(ROOT_DIR)/install_alacritty.sh || echo -e "\e[91mERROR\t install failed; remember to close all Alacritty instances first \e[39m"


.PHONY: virtualenvwrapper
virtualenvwrapper:    ## python virtual environments (virtualenvwrapper)
	$(call log_info,updating $@...)
	-bash -c "python3 -m pip install --user virtualenvwrapper"
	grep -q -F '#PYTHON_CUSTOMIZATIONS_START' $(BASHRC) || \
		printf '\n#PYTHON_CUSTOMIZATIONS_START\n#PYTHON_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#PYTHON_CUSTOMIZATIONS_START.*?#PYTHON_CUSTOMIZATIONS_END/`cat python-customizations`/se' $(BASHRC)


.PHONY: rc.conf
rc.conf:              ## ranger configuration
	$(call log_info,updating $@...)
	ranger --copy-config=all
	sed -i 's/set\ preview_images\ false/set\ preview_images\ true/' $(RC_CONF)
	sed -i 's/set\ preview_images_method\ w3m/set\ preview_images_method\ urxvt/' $(RC_CONF)


.PHONY: rxvt.conf
rxvt.conf:            ## rxvt configuration
	$(call log_info,updating $@...)
	# needs apt packatges: rxvt-unicode xsel
	$(call update_file,$(ROOT_DIR)/Xresources,$(RXVT_CONF))
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
	grep -q -F '#BASH_FUNCTIONS_START' $(BASHRC) || \
		printf '\n#BASH_FUNCTIONS_START\n#BASH_FUNCTIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#BASH_FUNCTIONS_START.*?#BASH_FUNCTIONS_END/`cat bash-functions`/se' $(BASHRC)
	

.PHONY: fzf
fzf:                  ## command-line fuzzy finder
	$(call log_info,updating $@...)
	$(call update_repo,$(FZF_URL),$(FZF))
	$(FZF)/install --all


.PHONY: python_packages
python_packages:      ## extra python package dependencies
	$(call log_info,updating $@...)
	python3 -m pip install --user grip                # for 'JamshedVesuna/vim-markdown-preview' 


.PHONY: gnome_config
gnome_config:         ## gnome desktop configuration
	$(call log_info,updating $@...)
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
	# gedit
	gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
	gsettings set org.gnome.gedit.preferences.editor display-right-margin true
	gsettings set org.gnome.gedit.preferences.editor tabs-size 4
	gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
	# cinnamon
	#gsettings set org.cinnamon.background slideshow-folder $(ROOT_DIR)/wallpapers
	#gsettings set org.cinnamon.background mode slideshow


.PHONY: git_config
git_config:           ## configure git
	git lfs install  # just need to call once after installing `git-lfs` from apt
	git config --global credential.helper cache  # cache user/pass for 15 minutes
