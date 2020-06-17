# helper scripts to install dotfiles
# __file__ Makefile

SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
VIMRC := $(HOME)/.vimrc
BASHRC := $(HOME)/.bashrc
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
tmux.conf:
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
	grep -q -F '#PYTHON_CUSTOMIZATIONS_START' $(BASHRC) || \
		printf '\n#PYTHON_CUSTOMIZATIONS_START\n#PYTHON_CUSTOMIZATIONS_END' >> $(BASHRC)
	perl -i -p0e 's/#PYTHON_CUSTOMIZATIONS_START.*?#PYTHON_CUSTOMIZATIONS_END/`cat python-customizations`/se' $(BASHRC)
	
.PHONY: plugins
plugins:              ## install vim plugins
	$(ROOT_DIR)/install_vim_pkgs.sh

.PHONY: depends
depends:
	$(ROOT_DIR)/install_dependencies.sh

.PHONY: vundle
vundle:               ## install vundle
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

.PHONY: backup
backup:               ## backup dotfiles
	cp $(VIMRC) $(HOME)/.vimrc.bak
	cp $(BASHRC) $(HOME)/.bashrc.bak
	cp $(INPUTRC) $(HOME)/.inputrc.bak
	cp $(TMUX_CONF) $(HOME)/.tmux.conf.bak

.PHONY: rxvt
rxvt:                 ## install ranger & urxvt for image preview
	$(ROOT_DIR)/install_ranger.sh
