#!/bin/bash

set -o nounset
set -o errexit
set -o xtrace

# Create user account with uid 2000 to guarantee it won't change in the
# future (because the default user id 1000 might already be taken).
useradd --create-home --home /err --shell /bin/bash --uid 2000 err
# Allow people to provide SSH keys to pull from private repositories.
mkdir /err/.ssh/
chown err:err /err/.ssh/

mkdir /err/data /err/virtualenv
chown err:err /err/data /err/virtualenv

if [[ $ERR_PYTHON_VERSION == "2" ]]; then
	runas err virtualenv --python /usr/bin/python2 /err/virtualenv
else
	runas err python3 -m venv /err/virtualenv
fi

# Install Err itself
runas err /err/virtualenv/bin/pip install $ERR_PACKAGE
# XMPP back-end dependencies
runas err /err/virtualenv/bin/pip install sleekxmpp pyasn1 pyasn1-modules
# IRC back-end dependencies
runas err /err/virtualenv/bin/pip install irc
# HypChat back-end dependencies
runas err /err/virtualenv/bin/pip install hypchat
# Slack back-end dependencies. Note: Installing from master because PyPI
# release is broken at this time.
runas err /err/virtualenv/bin/pip install https://github.com/slackhq/python-slackclient/archive/master.zip
# Telegram back-end dependencies
runas err /err/virtualenv/bin/pip install python-telegram-bot
