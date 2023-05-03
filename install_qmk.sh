#!/usr/bin/env sh

# WIP download / compile QMK

git clone git@github.com:teresi/qmk_firmware.git ~/qmk_firmware

cd ~/qmk_firmware && git remote add upstream https://github.com/qmk/qmk_firmware.git
cd ~/qmk_firmware && git remote add keychron https://github.com/Keychron/qmk_firmware.git

qmk setup  # NOTE this is interactive!


# use virtualenv but you'll need to install manually

# keychron K8 pro
# do NOT use the rule.mk, 'BLUETOOTH_ENABLE = yes', that will not compile, but bluetooth will still work without it!
# don't bother changing any of the rules
# use 'bluetooth_playground' branch of qmk fork
# use the default keymap
# edit the keymap:  keyboards/keychron/k8_pro/ansi/rgb/keymaps/default/keymap.c
# 
# $ make keychron/k8_pro/ansi/rgb:default
# $ qmk flash -kb keychron/k8_pro keychron_k8_pro_ansi_rgb_default.bin
# 
# to put into bootloader, remove spacebar, slide to off, hold reset, slide to cable, release reset
# re-run `qmk flash...` several times until it finishes uploading
