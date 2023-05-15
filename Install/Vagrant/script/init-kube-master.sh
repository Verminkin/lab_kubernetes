#!/bin/bash

if [[ $(hostname) == *"master"* ]]; then
  sudo -i -u vagrant bash << EOF
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    rm -rf join.sh
    kubeadm token create --print-join-command > join.sh
EOF
fi
