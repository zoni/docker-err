#!/bin/bash

set -o nounset
set -o errexit
set -o xtrace

APTINSTALL="apt-get install --no-install-recommends --yes"

echo LC_ALL="en_US.utf8" >> /etc/environment
echo DEBIAN_FRONTEND="noninteractive" >> /etc/environment
locale-gen en_US.UTF-8
. /etc/environment

if [[ $ERR_PYTHON_VERSION == "2" ]]; then
	PYTHON_PACKAGES="python python-dev python-virtualenv virtualenv python-pip"
elif [[ $ERR_PYTHON_VERSION == "3" ]]; then
	PYTHON_PACKAGES="python3 python3-dev python3-venv"
else
	echo "Unsupported Python version requested through ERR_PYTHON_VERSION"
	exit 1
fi

apt-get update
# Do a dist-upgrade because docker has not always updated their
# images in a timely manner after security updates were released.
apt-get dist-upgrade --no-install-recommends --yes

# Python and related packages itself (some dev libs for building C extensions)
$APTINSTALL $PYTHON_PACKAGES build-essential libssl-dev libffi-dev

# TLS certs and sudo are needed, curl and vim are tremendously useful when entering
# a container for debugging (while barely increasing image size)
# Git is needed to install nearly all plugins
$APTINSTALL ca-certificates sudo curl vim-tiny git
ln -s /usr/bin/vi /usr/bin/vim

apt-get autoremove
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb
