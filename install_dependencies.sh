#!/usr/bin/env bash

# install packages to host
# for generic packages that aren't tied to an install script


set -x
echo -e "\e[32mINFO  install OS dependencies...\e[39m"


# NB required for setting up our configuration
echo -e "\e[32mINFO      install compile-time dependencies...\e[39m"
sudo apt install git git-lfs                  # for downloading dependencies
sudo apt install python3-pip                  # for downloading dependencies


sudo apt install gir1.2-gtop-2.0              # for multi-core system monitor (cinnamon applet / jaszhix)

# NB required for running our configuration
echo -e "\e[32mINFO      install run-time dependencies...\e[39m"
sudo apt-get install tmux
sudo apt-get install fonts-powerline              # for airline unicode
sudo apt-get install vim-gnome                    # for vim / os clipboard integration
sudo apt-get install xdotool                      # for 'JamshedVesuna/vim-markdown-preview'

# NB required for rxvt
echo -e "\e[32mINFO      install rxvt dependencies...\e[39m"
sudo apt install rxvt-unicode xsel libx11-dev libxext-dev
