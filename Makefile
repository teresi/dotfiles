# helper scripts to install dotfiles
# __file__ Makefile
#
# NB using phony recipes (not creating files) is an anti-pattern for Make
# but is used b/c it's cleaner than adding switches to a bash script


SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
VIMRC := $(HOME)/.vimrc
VUNDLE := $(HOME)/.vim/bundle/Vundle.vim
BASHRC := $(HOME)/.bashrc
BASHPROFILE := $(HOME)/.bash_profile
INPUTRC := $(HOME)/.inputrc
TMUX_CONF := $(HOME)/.tmux.conf
ALACRITTY_CFG_DIR := $(HOME)/.config/alacritty
ALACRITTY_YML := $(ALACRITTY_CFG_DIR)/alacritty.yml
FZF := $(HOME)/.fzf


.PHONY: help
help:                 ## usage
	@echo Usage:  make [RECIPE]
	@echo "    recipes to configure dotfiles, tools, etc."
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


.PHONY: all
all: | config         ## setup user configs / programs
	$(MAKE) --no-print-directory -ik vundle
	$(MAKE) --no-print-directory -ik plugins
	$(MAKE) --no-print-directory -ik virtualenvwrapper
	$(MAKE) --no-print-directory -ik fzf
	$(MAKE) --no-print-directory -ik alacritty
	$(MAKE) --no-print-directory -ik python_extra


.PHONY: config
config:               ## copy configs
	$(MAKE) --no-print-directory -ik vimrc
	$(MAKE) --no-print-directory -ik bashrc
	$(MAKE) --no-print-directory -ik bashprofile
	$(MAKE) --no-print-directory -ik inputrc
	$(MAKE) --no-print-directory -ik tmux.conf
	$(MAKE) --no-print-directory -ik alacritty.yml
	$(MAKE) --no-print-directory -ik functions
	$(MAKE) --no-print-directory -ik git_config


.PHONY: depends
depends:              ## system dependencies
	$(ROOT_DIR)/install_dependencies.sh


.PHONY: vimrc
vimrc:                ## vim config
	cp $(ROOT_DIR)/vimrc $(VIMRC)


.PHONY: vundle
vundle:               ## vim package manager
	$(ROOT_DIR)/install_vundle.bash $(VUNDLE)


.PHONY: plugins
plugins:              ## download vim plugins
	$(ROOT_DIR)/install_vim_pkgs.sh


.PHONY: inputrc
inputrc:              ## command line config
	cp $(ROOT_DIR)/inputrc $(INPUTRC)


.PHONY: tmux.conf
tmux.conf:            ## tmux config
	cp $(ROOT_DIR)/tmux.conf $(TMUX_CONF)


.PHONY: bashrc
bashrc:               ## login shell config
	sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' $(BASHRC)
	sed -i 's/HISTSIZE=1000/HISTSIZE=16384/' $(BASHRC)
	sed -i 's/HISTFILESIZE=2000\n/HISTFILESIZE=65536/' $(BASHRC)
	# replace block of text between markers
	grep -q -F '#BASH_CUSTOMIZATIONS_START' $(BASHRC) || \
		printf '\n#BASH_CUSTOMIZATIONS_START\n#BASH_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#BASH_CUSTOMIZATIONS_START.*?#BASH_CUSTOMIZATIONS_END/`cat bash-customizations`/se' $(BASHRC)


.PHONY: bashprofile
bashprofile:          ## non-login shell config
	grep -q -F '#BASH_PROFILE_CUSTOMIZATIONS_START' $(BASHPROFILE) || \
		printf '\n#BASH_PROFILE_CUSTOMIZATIONS_START\n#BASH_PROFILE_CUSTOMIZATIONS_END' >> $(BASHPROFILE)
	perl -i -p0e 's/#BASH_PROFILE_CUSTOMIZATIONS_START.*?#BASH_PROFILE_CUSTOMIZATIONS_END/`cat bash-profile-customizations`/se' $(BASHPROFILE)


.PHONY: alacritty.yml ## alacritty terminal config
alacritty.yml: | $(ALACRITTY_CFG_DIR)  ## configuration for alacritty terminal
	cp $(ROOT_DIR)/alacritty.yml $(ALACRITTY_YML)


$(ALACRITTY_CFG_DIR): ## alacritty config directory
	mkdir -p $(ALACRITTY_CFG_DIR)


.PHONY: alacritty
alacritty:            ## compile alacritty terminal
	$(ROOT_DIR)/install_alacritty.sh


.PHONY: virtualenvwrapper
virtualenvwrapper:    ## python virtual environments (virtualenvwrapper)
	-bash -c "python3 -m pip install --user virtualenvwrapper"
	grep -q -F '#PYTHON_CUSTOMIZATIONS_START' $(BASHRC) || \
		printf '\n#PYTHON_CUSTOMIZATIONS_START\n#PYTHON_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#PYTHON_CUSTOMIZATIONS_START.*?#PYTHON_CUSTOMIZATIONS_END/`cat python-customizations`/se' $(BASHRC)


.PHONY: rc.conf
rc.conf:              ## ranger configuration
	ranger --copy-config=all
	sed -i 's/set\ preview_images\ false/set\ preview_images\ true/' ~/.config/ranger/rc.conf
	sed -i 's/set\ preview_images_method\ w3m/set\ preview_images_method\ urxvt/' ~/.config/ranger/rc.conf


.PHONY: backup
backup:               ## backup dotfiles
	cp $(VIMRC) $(HOME)/.vimrc.bak
	cp $(BASHRC) $(HOME)/.bashrc.bak
	cp $(INPUTRC) $(HOME)/.inputrc.bak
	cp $(TMUX_CONF) $(HOME)/.tmux.conf.bak
	cp $(ALACRITTY_YML) $(ALACRITTY_YML).bak


.PHONY: functions
functions:            ## bash helper functions
	grep -q -F '#BASH_FUNCTIONS_START' $(BASHRC) || \
		printf '\n#BASH_FUNCTIONS_START\n#BASH_FUNCTIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#BASH_FUNCTIONS_START.*?#BASH_FUNCTIONS_END/`cat bash-functions`/se' $(BASHRC)
	

.PHONY: fzf
fzf:                  ## command-line fuzzy finder
	$(ROOT_DIR)/install_fzf.bash $(FZF)


.PHONY: python_extra
python_extra:         ## extra python package dependencies
	$(ROOT_DIR)/install_python_extra.bash


.PHONY: gnome_config
gnome_config:         ## gnome desktop configuration
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
