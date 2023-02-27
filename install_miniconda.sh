#!/usr/bin/env bash

# install miniconda, python distribution and package manager
# NOTE there does not appear to be a way to only install the package manager `conda`
# NOTE 'miniconda' is preferred over 'anaconda' as the latter pre-installs 250+ python packages


_ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_ROOT_DIR/helpers.bash
_PYTHON=3.10
_PREFIX=$HOME/miniconda3  # MAGIC miniconda convention

_CONDA_310=https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh
_CONDA_39=https://repo.anaconda.com/miniconda/Miniconda3-py39_23.1.0-1-Linux-x86_64.sh
_CONDA_38=https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh
_CONDA_37=https://repo.anaconda.com/miniconda/Miniconda3-py37_23.1.0-1-Linux-x86_64.sh

_SHA_310=32d73e1bc33fda089d7cd9ef4c1be542616bd8e437d1f77afeeaf7afdb019787
_SHA_39=5dc619babc1d19d6688617966251a38d245cb93d69066ccde9a013e1ebb5bf18
_SHA_38=640b7dceee6fad10cb7e7b54667b2945c4d6f57625d062b2b0952b7f3a908ab7
_SHA_37=fc96109ea96493e31f70abbc5cae58e80634480c0686ab46924549ac41176812


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
_CONDA=$_CONDA_310
_SHA=$_SHA_310

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
