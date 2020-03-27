# helper scripts to install vim configuration
# __file__ Makefile

SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
USER_HOME := /home/$(USER)

.PHONY: all vimrc install vundle backup

all:
	make vimrc
	make -ik packages

vimrc:                ## copy vimrc to the current user
	cp $(ROOT_DIR)/vimrc $(USER_HOME)/.vimrc

packages:             ## install plugins
	$(ROOT_DIR)/install_vim_pkgs.sh

vundle:               ## install vundle
	git clone https://github.com/VundleVim/Vundle.vim.git $(USER_HOME)/.vim/bundle/Vundle.vim

backup:               ## backup your vimrc
	cp $(USER_HOME)/.vimrc $(USER_HOME)/.vimrc.bak
