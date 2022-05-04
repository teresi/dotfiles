#!/usr/bin/env bash

# download vundle for vim package management
# Args:
#    $1: destination to download vundle to

_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
notify "download VUNDLE..."

VUNDLE_DEST="$HOME/.vim/bundle/Vundle.vim"
VUNDLE_GIT_URL=https://github.com/VundleVim/Vundle.vim.git

if [ $# -eq 1 ] && [ ! -z "$1" ]; then
	VUNDLE_DEST="$1"
fi

update_repo_to_master "$VUNDLE_GIT_URL" "$VUNDLE_DEST"
