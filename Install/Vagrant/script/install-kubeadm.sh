#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
printf "###################################################\n               KUBERNETES  \n###################################################\n"
printf "---------------------------------------------------\n               INSTALL   \n---------------------------------------------------\n"
sudo apt-get update
sudo apt-get install --quiet --yes apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install --quiet --yes kubelet kubeadm kubectl
printf "---------------------------------------------------\n               KubeADM   \n---------------------------------------------------\n"
printf "---------------------------------------------------\n               KUBElet   \n---------------------------------------------------\n"
printf "---------------------------------------------------\n               KUBEctl   \n---------------------------------------------------\n"
sudo apt-mark hold kubelet kubeadm kubectl


printf "||||||||||||||||||||||||||||||||||||||||||||||||\n               DONE       \n||||||||||||||||||||||||||||||||||||||||||||||||\n"
