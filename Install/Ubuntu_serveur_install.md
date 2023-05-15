# Installation Guide

This guide provides step-by-step instructions for installing Docker and Kubernetes on your system. Please follow the instructions carefully to ensure a successful installation.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

- A system running a Linux distribution (e.g., Ubuntu)
- Internet connectivity

## Step 1: Update and Upgrade Packages

First, let's update and upgrade the packages on your system. Open a terminal and run the following commands:

```shell
sudo apt update
sudo apt upgrade
```

## Step 2: Install Docker

Next, we'll install Docker on your system. Docker is a containerization platform that allows you to run applications in isolated environments.

```shell
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
```

## Step 3: Install Kubernetes

Now, let's install Kubernetes on your system. Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications.

```shell
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

## Step 4: Configure System Settings

To ensure proper functioning of Kubernetes, we need to configure some system settings. Open a terminal and run the following commands:

```shell
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo nano /etc/modules-load.d/containerd.conf
```

In the `containerd.conf` file, add the following lines:

```
overlay
br_netfilter
```

Save the file and exit the editor.

Next, open the `kubernetes.conf` file for editing:

```shell
sudo nano /etc/sysctl.d/kubernetes.conf
```

Add the following lines to the file:

```
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
```

Save the file and exit the editor.

Now, apply the sysctl settings:

```shell
sudo sysctl --system
```

## Step 5: Set Hostnames (Optional)

If you want to set custom hostnames for your nodes, you can run the following commands:

```shell
sudo hostnamectl set-hostname master-node
sudo hostnamectl set-hostname worker01
sudo hostnamectl set-hostname worker02
sudo hostnamectl set-hostname vault
sudo hostnamectl set-hostname monitoring
```

Replace `master-node`, `worker01`, `worker02`, `vault`, and `monitoring` with your desired hostnames.

## Step 6: Configure Docker

Next, we'll configure Docker to work with Kubernetes. Open the Docker configuration file for editing:

```shell
sudo nano /etc/docker/daemon.json
```

Add the following configuration to the file:

```json
{
   "exec-opts": ["native.cgroupdriver=systemd"],
   "log-driver": "json-file",
   "log-opts": {
      "max-size": "100m"
   },
   "storage-driver": "overlay2"
}
```

Save the file and exit