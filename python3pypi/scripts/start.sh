#!/bin/bash

set -o nounset
set -o errexit

usage() {
	echo "Usage:" 2>&1
	echo "" 2>&1
	echo "  shell       -- Start an interactive user shell" 2>&1
	echo "  rootshell   -- Start an interactive root shell" 2>&1
	echo "  err         -- Start Err" 2>&1
}

if [[ $# -lt 1 ]]; then
	usage
	exit 1
fi

cmd=$1
shift

case $cmd in
	"shell")
		cd /err
		exec runas err /bin/bash "$@"
		;;
	"rootshell")
		exec /bin/bash "$@"
		;;
	"err")
		cd /err
		exec runas err /err/virtualenv/bin/err.py "$@"
		;;
	*)
		usage
		exit 1
		;;
esac
