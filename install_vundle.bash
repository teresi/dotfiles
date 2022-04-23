#!/usr/bin/env bash

# download vundle for vim package management

_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
notify "download VUNDLE..."

VUNDLE_DEST="$(HOME)/.vim/bundle/Vundle.vim"
VUNDLE_GIT_URL=https://github.com/VundleVim/Vundle.vim.git

git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

if [ $# -eq 1 ] && [ ! -z "$1" ]; then
	VUNDLE_DEST="$1"
fi

update_repo_to_master "$FZF_GIT_URL" "$FZF_DEST"
"$FZF_DEST"/install --all
