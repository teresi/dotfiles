#!/usr/bin/env bash

# install ZEPHYR, an Real Time OS for embedded systems
#    this is a dependency for ZMK, a firmware for keyboards

# NB
#    depends on virtualenvwrapper
#    creates / activates an env called "zephyr"

# SEE
#    https://docs.zephyrproject.org/3.2.0/introduction/index.html
#    https://docs.zephyrproject.org/3.2.0/develop/getting_started/index.html
#    https://zmk.dev/docs


_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash

Z_REPO=https://github.com/zephyrproject-rtos/zephyr
Z_SRC="$HOME"/zephyrproject
Z_VENV=zephyr
Z_DEP="git cmake ninja-build gperf ccache dfu-util device-tree-compiler wget python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1"


check_dep ()
{
	are_packages_missing "$Z_DEP"
}


update_zephyr ()
{
	set -e
	source `which virtualenvwrapper.sh` \
		|| (error "could not source virtualenvwrapper, is virtualenvwrapper.sh in the path?" && false)
	set +e

	lsvirtualenv | grep -q $Z_VENV || (mkvirtualenv -a "$Z_SRC" "$Z_VENV") && true
	workon "$Z_VENV"  # NB `workon` raises errors so do not call under `set -ex`

	if [[ "$VIRTUAL_ENV" == "" ]]
	then
		error "could not activate virtual env $Z_VENV"
		exit 1
	fi

	set -ex
	pip install west

	cd "$HOME"
	if [ ! -d "$Z_SRC" ]; then
		west init -m "$Z_REPO" zephyrproject
	fi

	cd "$Z_SRC"
	west update
	west zephyr-export
	pip install -r "$Z_SRC"/zephyr/scripts/requirements.txt
		
}


# TODO consider installing to `~/.local` instead of `~`?
install_sdk ()
{
	cd ~
	wget -c https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.0/zephyr-sdk-0.15.0_linux-x86_64.tar.gz
	wget -O - https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.0/sha256.sum | shasum --check --ignore-missing
	tar xvf zephyr-sdk-0.15.0_linux-x86_64.tar.gz
	cd zephyr-sdk-0.15.0
	./setup.sh
	set -ex
	sudo cp ~/zephyr-sdk-0.15.0/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
	sudo udevadm control --reload
	set +ex
}


notify "compile zephyr..."

notify "checking dependencies..."
check_dep

notify "updating zephyr project..."
update_zephyr

notify "installing SDK..."
install_sdk

