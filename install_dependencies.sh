#!/bin/bash

# install apt / python packages to host

set -ex
sudo apt-get install fonts-powerline              # unicode
sudo apt-get install xdotool                      # for 'JamshedVesuna/vim-markdown-preview'
python3 -m pip install --user grip                # for 'JamshedVesuna/vim-markdown-preview' 
python3 -m pip install --user virtualenvwrapper   # python envs
