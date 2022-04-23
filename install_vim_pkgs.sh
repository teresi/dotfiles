#!/usr/bin/env bash

# download plugins

echo -e "\e[32mINFO  download VIM plugins...\e[39m"
vim --noplugin -E +PluginInstall +qall
