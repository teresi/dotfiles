#!/usr/bin/env bash

# install miniconda, python distribution and package manager
# NOTE there does not appear to be a way to only install the package manager `conda`
# NOTE 'miniconda' is preferred over 'anaconda' as the latter pre-installs 250+ python packages


_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
_PYTHON=3.13
_PREFIX=$HOME/miniconda3  # MAGIC miniconda convention

_CONDA_313=https://repo.anaconda.com/miniconda/Miniconda3-py313_25.7.0-2-Linux-x86_64.sh
_SHA_313=dda3629462ba1cfa72eb74535214c2e315c77f1cfb0f02046537e99f1bf64abc

_CONDA_312=https://repo.anaconda.com/miniconda/Miniconda3-py312_25.7.0-2-Linux-x86_64.sh
_SHA_312=188b5d94ab3acefdeaebd7cb470d2fb74a3280563c77075de6e3e1d58d84ab0a

_CONDA_311=https://repo.anaconda.com/miniconda/Miniconda3-py311_25.7.0-2-Linux-x86_64.sh
_SHA_311=e072c062a7e017732c97963ef0d9a1cb474b92b7f25c8a032f9632cfe75add4f


usage () {
	echo "$(basename $0) [OPTION]"
	echo ""
	echo "install miniconda"
	echo ""
	echo "-h, --help         show usage"
	echo "-p, --python       python version (3.10)"
	echo "--prefix           installation prefix"
	echo ""
}


while [[ $# -gt 0 ]]
do
	key="${1}"
	case ${key} in
	-p|--python)
		_PYTHON=$2; shift 2;;
	--prefix)
		_PREFIX=$2; shift 2;;
	-h|--help)
		usage; shift;;
	*)    # unknown option
		shift;;
	esac
	shift
done


# TODO add check if prefix is bad

set -ex

# TODO add selection for python version
_CONDA=$_CONDA_313
_SHA=$_SHA_313

notify "downloading miniconda $_PYTHON..."
wget -c $_CONDA -P /tmp/

_CONDA_FILE=$(basename $_CONDA)

echo "${_SHA} /tmp/$_CONDA_FILE" | sha256sum --strict -c || error "bad SHA256 on download!" exit 1

_PREFIX_FLAG=
if [ -n "$_PREFIX" ]; then
	_PREFIX_FLAG="-p $_PREFIX"
fi

notify "installing miniconda $_PYTHON"
bash /tmp/$_CONDA_FILE -bu $_PREFIX_FLAG

notify "updating configuration"
$_PREFIX/bin/conda init bash
$_PREFIX/bin/conda config --set auto_activate_base false

notify "success!"
notify "please source your bashrc or etc."
