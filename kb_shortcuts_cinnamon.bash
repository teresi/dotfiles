#!/usr/bin/env bash

# set keyboard shortcuts
# sets home folder and terminal emulator

# SEE https://blog.programster.org/using-the-cli-to-set-custom-keyboard-shortcuts


BEGINNING="gsettings set org.cinnamon.keybindings.custom-keybinding:"
KEY_PATH="/org/cinnamon/desktop/keybindings/custom-keybindings"

if [ -z `which nautilus` ]; then
	echo -e "\e[91mERROR\tskipping nautilus shortcut, nautilus not in the path \e[39m"
	gsettings set org.cinnamon.desktop.keybindings.media-keys home [\'XF68Explorer\', \'<Super>e\']
else
	${BEGINNING}${KEY_PATH}/custom0/ name "Nautilus"
	${BEGINNING}${KEY_PATH}/custom0/ command "$(which nautilus) --new-window"
	${BEGINNING}${KEY_PATH}/custom0/ binding "<Super>e"
fi

# NB this could also be set using /org/cinnamon/desktop/applications/terminal/
if [ -z `which alacritty` ]; then
	echo -e "\e[91mERROR\tskipping alacritty shortcut, alacritty not in the path \e[39m"
	gsettings set org.cinnamon.desktop.keybindings.media-keys terminal ['<Primary><Alt>t']
else
	gsettings set org.cinnamon.desktop.keybindings.media-keys terminal []  # need to remove default shortcut first
	${BEGINNING}${KEY_PATH}/custom1/ name "Alacritty"
	${BEGINNING}${KEY_PATH}/custom1/ command "$(which alacritty)"
	${BEGINNING}${KEY_PATH}/custom1/ binding "<Primary><Alt>t"
fi

unset KEY_PATH
unset BEGINNING
