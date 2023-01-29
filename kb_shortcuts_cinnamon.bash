#!/usr/bin/env bash

# set keyboard shortcuts
# sets home folder and terminal emulator

# SEE https://blog.programster.org/using-the-cli-to-set-custom-keyboard-shortcuts


# NB this could also be set using /org/cinnamon/desktop/applications/terminal/
dconf write /org/cinnamon/desktop/keybindings/custom-list "['custom0']"
dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom0/command "'alacritty'"
dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom0/name "'Alacritty'"

if [ -z `which alacritty` ]; then
	echo -e "\e[91mERROR\tskipping alacritty shortcut, alacritty not in the path \e[39m"
	gsettings set org.cinnamon.desktop.keybindings.media-keys terminal ['<Primary><Alt>t']
else
	echo "setting alacritty..."
	gsettings set org.cinnamon.desktop.keybindings.media-keys terminal []  # remove conflicting default shortcut
	dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom0/binding "['<Primary><Alt>t']"
fi


dconf write /org/cinnamon/desktop/keybindings/custom-list "['custom0', 'custom1']"
dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom1/command "'nautilus --new-window'"
dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom1/name "'nautilus'"

if [ -z `which nautilus` ]; then
	echo -e "\e[91mERROR\tskipping nautilus shortcut, nautilus not in the path \e[39m"
	dconf write /org/gnome/shell/extensiors/ding/use-nemo "true"
	gsettings set org.cinnamon.desktop.keybindings.media-keys home [\'XF68Explorer\', \'<Super>e\']
else
	dconf write /org/gnome/shell/extensiors/ding/use-nemo "false"
	gsettings set org.cinnamon.desktop.keybindings.media-keys home []  # remove conflicting default shortcut
	dconf write /org/cinnamon/desktop/keybindings/custom-keybindings/custom1/binding "['<Super>e']"
fi
