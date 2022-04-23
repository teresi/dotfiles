#!/usr/bin/env bash

# install command line fuzzy finder: interactive filter command

_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
notify "download FZF..."

FZF_DEST="$HOME/.fzf"
FZF_GIT_URL=https://github.com/junegunn/fzf.git

if [ $# -eq 1 ] && [ ! -z "$1" ]; then
	FZF_DEST="$1"
fi

update_repo_to_master "$FZF_GIT_URL" "$FZF_DEST"
"$FZF_DEST"/install --all
