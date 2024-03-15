#!/usr/bin/env bash

# add certificate to Git, in order to access a Git server

# important if you haven't installed ca-certificates through Apt
# of if you have a self signed cert

# this can be used as an alternative to diabling ssl for git-lfs:
#	git config --global http.sslVerify false    # no need if you trust the cert
#	git config --global --unset http.sslVerify  # re-enable if you previously disabled


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/helpers.bash

_addr=github.com
_port=443

usage () {
	echo "$(basename $0) [OPTION]"
	echo ""
	echo "trust a Git server certificate"
	echo ""
	echo "    useful for example w/ self signed certificates"
	echo "    recommended instead of using: git config http.sslVerify false"
	echo ""
	echo "-h, --help         show usage"
	echo "-p, --port         port ($_port)"
	echo "-u, --uri          address ($_addr)"
	echo ""
}

while [[ $# -gt 0 ]]
do
	key="${1}"
	case ${key} in
	-p|--port)
		_port=$2; shift 2;;
	-u|--uri)
		_addr=$2; shift 2;;
	-h|--help)
		usage; exit;;
	*)    # unknown option
		shift;;
	esac
	shift
done


# MAGIC arbitrary folder
_cert_dir="$HOME"/git-certs/
_cert="$_cert_dir"/"$_addr".crt
mkdir -p "$_cert_dir"

notify "downloading cert... $_addr"
echo -n \
	| openssl s_client -showcerts -connect "$_addr":"$_port" 2>/dev/null \
	| sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
	> $_cert
notify "downloading cert... SEE  $_cert"
notify "downloading cert... DONE"
echo ""

notify "trusting cert for GIT..."
git config --global "http.https://$_addr/.sslCAinfo" "$_cert"
notify "trusting cert for GIT...  SEE ~/.gitconfig"
notify "trusting cert for GIT...  DONE"
echo ""

notify "your global settings are..."
echo ""
git config --global --list
