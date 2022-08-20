#!/usr/bin/env bash

# download tmux plugin manager
# Args:
#    $1: destination to download tmp to

_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
notify "download Tmux Plugin Manager..."

_tpm_dest="$HOME/.tmux/plugins/tmp"
_tpm_git_url=https://github.com/tmux-plugins/tpm

if [ $# -eq 1 ] && [ ! -z "$1" ]; then
	_tpm_dest="$1"
fi

update_repo_to_master "$_tpm_dest" "$tpm_git_url"
