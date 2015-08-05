#!/bin/bash

# Copies over the README, provisioners/* and scripts/* to the
# subdirectories which is needed because symlinks don't work
# (they'll be outside the docker build context)

rm -vrf python*/scripts/* python*/provisioners/*
for dir in python*master python*pypi
do
	test -e $dir/provisioners || mkdir $dir/provisioners
	test -e $dir/scripts || mkdir $dir/scripts
	cp -va provisioners/* $dir/provisioners/
	cp -va scripts/* $dir/scripts/
	cp -va README.md $dir/
done
