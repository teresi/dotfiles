#!/bin/bash 
# install ranger & rxvt (terminal) w/ image preview

# gnome-terminal was too difficult to get working for ranger w/ image preview
# instead use rxvt

set -ex
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# ubuntu dependencies
sudo apt-get install libx11-dev libxext-dev
sudo apt-get install ranger
python3 -m pip install --user ueberzug

# need to run ranger in xvrt for iimages
sudo apt-get install rxvt-unicode xsel

# sane defaults
cp $ROOT_DIR/Xresources /home/`whoami`/.Xresources
xrdb -merge ~/.Xresources

