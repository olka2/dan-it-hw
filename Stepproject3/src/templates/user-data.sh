#!/bin/bash
set -eux

USER=ubuntu
HOME_DIR=/home/$USER

mkdir -p $HOME_DIR/.ssh
echo "${public_key}" >> $HOME_DIR/.ssh/authorized_keys

chown -R $USER:$USER $HOME_DIR/.ssh
chmod 700 $HOME_DIR/.ssh
chmod 600 $HOME_DIR/.ssh/authorized_keys
