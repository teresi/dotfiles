#!/usr/bin/env bash

# install ZMK, an open source keyboard firmware

# SEE
#    https://zmk.dev/docs/development/setup
#    https://zmk.dev/docs/development/build-flash

pipx install west

_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash

# NB using fork from slicemk b/c that can compile for his board
#Z_REPO=https://github.com/zmkfirmware/zmk.git
Z_REPO=https://github.com/slicemk/zmk
Z_DIR="$HOME"/zmk
Z_VENV=zmk

set -ex

# NB zmk uses 'main' not 'master'
notify "updating $Z_REPO"
if [[ ! -d $Z_DIR ]]; then
	notify "\tgit clone $Z_REPO $Z_DIR"
	git clone $Z_REPO $Z_DIR
fi
notify "\tgit checkout main -C $Z_DIR"
git -C "$Z_DIR" checkout main
notify "\tgit pull origin main -C $Z_DIR"
git -C "$Z_DIR" pull origin main

cd $Z_DIR
notify "initialize ZMK"
# NB west init will fail if it already exists, but this is OK
west init -l app/ 2> /dev/null || true
notify "update ZMK, this may take a while..."
west update

west zephyr-export

set +ex

set -e
source `which virtualenvwrapper.sh` \
	|| (error "could not source virtualenvwrapper, is virtualenvwrapper.sh in the path?" && false)
set +e

lsvirtualenv | grep -q "$Z_VENV" || (mkvirtualenv -a "$Z_DIR" "$Z_VENV") && true
workon "$Z_VENV"  # NB `workon` raises errors so do not call under `set -ex`

if [[ "$VIRTUAL_ENV" == "" ]]
then
	error "could not activate virtual env $Z_VENV"
	exit 1
fi

pip install -r "$Z_DIR"/zephyr/scripts/requirements.txt


# TODO
# need to clone the configs, find them
# need to update the configs
# need to figure out if zephyr and zmk are built?, and rebuild if necessary?
# need a rule that takes the configs and builds the uf2, copies it to Download or etc
# add bash completion?

# https://zmk.dev/docs/development/build-flash
# BOARD=raytac_mdbt50q_rx_green
# SHIELD=slicemk_ergodox_dongle
# ZCONFIG="$HOME"/ergodox-zmk-config/config
# Z_APP="$Z_DIR"/app
# workon $Z_ENV
# west build -s ${Z_APP} -b ${BOARD} -- \
#	-DSHIELD=${SHIELD} \
#	-DZMK_CONFIG=${ZCONFIG}

# # the output went to ~/zmk/app/build/zephyr/zmk.uf2


# TODO print instructions
