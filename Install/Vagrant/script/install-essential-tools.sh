#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

printf "###################################################\n               ESSENTIAL TOOLS\n###################################################\n"
sudo systemctl stop display-manager
printf "---------------------------------------------------\n               UPDATE    \n---------------------------------------------------\n"
sudo apt-get update
sudo apt-get --quiet --yes dist-upgrade
sudo apt-get --quiet --yes --no-install-recommend install git vim curl wget htop tmux jq net-tools console-data
sudo loadkeys -b fr

printf "---------------------------------------------------\n               VIM      \n---------------------------------------------------\n"
cp -v /vagrant/.vimrc ~/conf/.vimrc
cp -v /vagrant/.tmux.conf ~/conf/.tmux.conf
sudo systemctl start display-manager

printf "||||||||||||||||||||||||||||||||||||||||||||||||\n               DONE  TOOLS     \n||||||||||||||||||||||||||||||||||||||||||||||||\n"
