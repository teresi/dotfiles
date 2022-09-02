#!/usr/bin/env bash

# set keyboard shortcuts
# sets home folder and terminal emulator

# SEE https://blog.programster.org/using-the-cli-to-set-custom-keyboard-shortcuts


BEGINNING="gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
KEY_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$KEY_PATH/custom0/', '$KEY_PATH/custom1/']"

if [ -z `which nautilus` ]; then
	echo -e "\e[91mERROR\tskipping nautilus shortcut, nautilus not in the path \e[39m"
	gsettings set org.cinnamon.desktop.keybindings.media-keys home [\'XF68Explorer\', \'<Super>e\']
else
	$BEGINNING/custom0/ name "Nautilus"
	$BEGINNING/custom0/ command "$(which nautilus) --new-window"
	$BEGINNING/custom0/ binding "<Super>e"
fi

# NB this could also be set using /org/gnome/desktop/applications/terminal/
# NB setting default terminal in gnome appears to require sudo:  sudo update-alternatives --config gnome-terminal
if [ -z `which alacritty` ]; then
	echo -e "\e[91mERROR\tskipping gnome alacritty shortcut, alacritty not in the path \e[39m"
	gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Primary><Alt>t']"
else
	gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "[]"  # need to remove default shortcut first
	$BEGINNING/custom1/ name "Alacritty"
	$BEGINNING/custom1/ command "/home/$USER/.local/bin/alacritty"
	$BEGINNING/custom1/ binding "<Primary><Alt>t"
fi

unset KEY_PATH
unset BEGINNING
