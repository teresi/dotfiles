# helper scripts to install dotfiles
# __file__ Makefile
#
# FYI having this many phony recipes (not creating files) is an anti-pattern
# for makefiles, but is done here as it is cleaner than adding this many switches
# to a bash file

SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
VIMRC := $(HOME)/.vimrc
BASHRC := $(HOME)/.bashrc
BASHPROFILE := $(HOME)/.bash_profile
INPUTRC := $(HOME)/.inputrc
TMUX_CONF := $(HOME)/.tmux.conf


.PHONY: help
help:                 ## show this help
	@echo Usage:  make [RECIPE]
	@echo Helper phony recipes to customize your environment
	@echo *WARNING* backup your current vimrc before overwriting!
	@echo Recipes:
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: all
all:                  ## overwrite vimrc / bashrc, download plugins (requires Vundle)
	$(MAKE) --no-print-directory vimrc
	$(MAKE) --no-print-directory -ik plugins
	$(MAKE) --no-print-directory -ik bashrc
	$(MAKE) --no-print-directory -ik inputrc
	$(MAKE) --no-print-directory -ik tmux.conf
	$(MAKE) --no-print-directory -ik virtualenvwrapper

.PHONY: install
install:              ## install all system dependencies
	$(MAKE) --no-print-directory -ik depends

.PHONY: vimrc
vimrc:                ## overwrite /home/$USER/.vimrc for vim settings
	cp $(ROOT_DIR)/vimrc $(VIMRC)

.PHONY: inputrc
inputrc:              ## overwrite /home/$USER/.inputrc for vi mode in the terminal
	cp $(ROOT_DIR)/inputrc $(INPUTRC)

.PHONY: tmux.conf
tmux.conf:            ## configuration for tmux
	cp $(ROOT_DIR)/tmux.conf $(TMUX_CONF)

.PHONY: bashrc
bashrc:               ## customize bash
	sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' $(BASHRC)
	sed -i 's/HISTSIZE=1000/HISTSIZE=16384/' $(BASHRC)
	sed -i 's/HISTFILESIZE=2000\n/HISTFILESIZE=65536/' $(BASHRC)
	# replace block of text between markers
	grep -q -F '#BASH_CUSTOMIZATIONS_START' $(BASHRC) || \
		printf '\n#BASH_CUSTOMIZATIONS_START\n#BASH_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#BASH_CUSTOMIZATIONS_START.*?#BASH_CUSTOMIZATIONS_END/`cat bash-customizations`/se' $(BASHRC)

.PHONY: bashprofile
bashprofile:
	grep -q -F '#BASH_PROFILE_CUSTOMIZATIONS_START' $(BASHPROFILE) || \
		printf '\n#BASH_PROFILE_CUSTOMIZATIONS_START\n#BASH_PROFILE_CUSTOMIZATIONS_END' >> $(BASHPROFILE)
	perl -i -p0e 's/#BASH_PROFILE_CUSTOMIZATIONS_START.*?#BASH_PROFILE_CUSTOMIZATIONS_END/`cat bash-profile-customizations`/se' $(BASHPROFILE)


.PHONY: virtualenvwrapper
virtualenvwrapper:    ## variables for python virtual env wrapper
	grep -q -F '#PYTHON_CUSTOMIZATIONS_START' $(BASHRC) || \
		printf '\n#PYTHON_CUSTOMIZATIONS_START\n#PYTHON_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#PYTHON_CUSTOMIZATIONS_START.*?#PYTHON_CUSTOMIZATIONS_END/`cat python-customizations`/se' $(BASHRC)
	
.PHONY: plugins
plugins:              ## install vim plugins
	$(ROOT_DIR)/install_vim_pkgs.sh

.PHONY: depends
depends:              ## install apt / python packages to host
	$(ROOT_DIR)/install_dependencies.sh

.PHONY: vundle
vundle:               ## install vundle
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

.PHONY: backup
backup:               ## backup dotfiles (vim / bach / inputrc / tmux)
	cp $(VIMRC) $(HOME)/.vimrc.bak
	cp $(BASHRC) $(HOME)/.bashrc.bak
	cp $(INPUTRC) $(HOME)/.inputrc.bak
	cp $(TMUX_CONF) $(HOME)/.tmux.conf.bak

.PHONY: rxvt
rxvt:                 ## install ranger & urxvt for image preview
	$(ROOT_DIR)/install_ranger.sh
