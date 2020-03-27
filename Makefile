# helper scripts to install vim configuration
# __file__ Makefile

SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
USER_HOME := /home/$(USER)
VIMRC := $(USER_HOME)/.vimrc
BASHRC := $(USER_HOME)/.bashrc


.PHONY:
help:                 ## show this help
	@echo Usage:  make [RECIPE]
	@echo Helper phony recipes to customize your environment
	@echo *WARNING* backup your current vimrc before overwriting!
	@echo Recipes:
	@echo
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY:
all:                  ## overwrite vimrc / bashrc, download plugins (requires Vundle)
	$(MAKE) --no-print-directory vimrc
	$(MAKE) --no-print-directory -ik plugins
	$(MAKE) --no-print-directory -ik bashrc

.PHONY:
vimrc:                ## overwrite /home/$USER/.vimrc
	cp $(ROOT_DIR)/vimrc $(VIMRC)

.PHONY:
plugins:              ## install vim plugins
	$(ROOT_DIR)/install_vim_pkgs.sh

.PHONY:
vundle:               ## install vundle
	git clone https://github.com/VundleVim/Vundle.vim.git $(USER_HOME)/.vim/bundle/Vundle.vim

.PHONY:
backup:               ## backup your vimrc
	cp $(VIMRC) $(USER_HOME)/.vimrc.bak

.PHONY:
bashrc:               ## customize bash
	sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' $(BASHRC)
	sed -i 's/HISTSIZE=1000/HISTSIZE=16384/' $(BASHRC)
	sed -i 's/HISTFILESIZE=2000\n/HISTFILESIZE=65536/' $(BASHRC)
	# replace block of text between markers
	grep -q -F '#BASH_CUSTOMIZATIONS_START' $(BASHRC) || printf '\n#BASH_CUSTOMIZATIONS_START\n#BASH_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#BASH_CUSTOMIZATIONS_START.*?#BASH_CUSTOMIZATIONS_END/`cat bash-customizations`/se' $(BASHRC)

