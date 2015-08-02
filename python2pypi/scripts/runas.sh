#!/bin/bash

if [[ $# -lt 2 ]]; then
        echo 'Usage: runas <user> <command> [args..]' 2>&1
        exit 1
fi

TARGET_USER="$1"
shift

exec sudo --preserve-env --set-home --non-interactive --user "$TARGET_USER" -- "$@"
