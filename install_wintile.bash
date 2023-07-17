#!/usr/bin/env bash

# install gnome shell wintile for quarter tiling

_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
notify "download Wintile..."

_wintile_addr=https://github.com/Fmstrat/wintile.git
_wintile_dir="$HOME/wintile"

update_repo_to_master "$_wintile_addr" "$_wintile_dir"
cd "$_wintile_dir"
./build.sh
unzip -o -d wintile@nowsci.com wintile@nowsci.com.zip
mkdir -p ~/.local/share/gnome-shell/extensions/
cp -r wintile@nowsci.com ~/.local/share/gnome-shell/extensions/

notify "please restart your gnome shell session! <Alt>+<F2>, run 'r'"

gnome-extensions enable wintile@nowsci.com
