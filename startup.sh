#! /bin/bash

vagrant destroy base -f  # insert guard
rm -f package.box
vagrant up base
vagrant package base
vagrant box add opscode-ubuntu-14.04a package.box -f
rm -f package.box
vagrant destroy base -f