# helper scripts to install vim configuration
# __file__ Makefile

SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
VIMRC := $(HOME)/.vimrc
BASHRC := $(HOME)/.bashrc
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

.PHONY: vimrc
vimrc:                ## overwrite /home/$USER/.vimrc
	cp $(ROOT_DIR)/vimrc $(VIMRC)

.PHONY: plugins
plugins:              ## install vim plugins
	$(ROOT_DIR)/install_vim_pkgs.sh

.PHONY: vundle
vundle:               ## install vundle
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

.PHONY: backup
backup:               ## backup your vimrc
	cp $(VIMRC) $(HOME)/.vimrc.bak

.PHONY: bashrc
bashrc:               ## customize bash
	sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' $(BASHRC)
	sed -i 's/HISTSIZE=1000/HISTSIZE=16384/' $(BASHRC)
	sed -i 's/HISTFILESIZE=2000\n/HISTFILESIZE=65536/' $(BASHRC)
	# replace block of text between markers
	grep -q -F '#BASH_CUSTOMIZATIONS_START' $(BASHRC) || printf '\n#BASH_CUSTOMIZATIONS_START\n#BASH_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#BASH_CUSTOMIZATIONS_START.*?#BASH_CUSTOMIZATIONS_END/`cat bash-customizations`/se' $(BASHRC)

.PHONY: tmux.conf
tmux.conf:
	cp $(ROOT_DIR)/tmux.conf $(TMUX_CONF)
