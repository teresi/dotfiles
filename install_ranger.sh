#!/usr/bin/env bash

# install ranger & rxvt (terminal) w/ image preview

# FUTURE separate ranger configs / Rxvt config

# gnome-terminal was too difficult to get working for ranger w/ image preview
# instead use rxvt

set -ex
_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo -e "\e[32mINFO  setup ranger / RXVT...\e[39m"

# TODO double check need for these apt pkgs
# rxvt-unicode xsel libx11-dev libxext-dev

# ranger w/ sane defaults
sudo apt-get install ranger
ranger --copy-config=all
sed -i 's/set\ preview_images\ false/set\ preview_images\ true/' ~/.config/ranger/rc.conf
sed -i 's/set\ preview_images_method\ w3m/set\ preview_images_method\ w3m/' ~/.config/ranger/rc.conf
