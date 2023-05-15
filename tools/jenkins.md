# Setting up a Kubernetes Cluster


Before getting started, you need to update the package list and upgrade the installed packages on your system.


```bash
sudo apt update
sudo apt upgrade
```

## Installing Docker

Docker is a containerization platform that we'll use to run the Kubernetes components. To install Docker, run the following commands:


```bash
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl status docker
sudo systemctl start docker
```

## Installing Kubernetes

Next, we'll install the Kubernetes components. First, add the Kubernetes signing key to your system:


```bash
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
```

## Then install the necessary packages:


```bash
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

## Configuring System Settings

We'll now configure the system settings needed for Kubernetes. First, disable swap:


```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

Next, add the necessary kernel modules to load at boot time:


```bash
sudo nano  /etc/modules-load.d/containerd.conf
```
#### Add the following two lines
overlay
br_netfilter

Then load the kernel modules:


```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

#### Add the following settings to the sysctl configuration:


```bash
sudo nano /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
```

Apply the sysctl settings:


```bash
sudo sysctl --system
```

## Set the hostnames for your machine(s):


```bash
sudo hostnamectl set-hostname master-node
sudo hostnamectl set-hostname worker01
sudo hostnamectl set-hostname worker02
sudo hostnamectl set-hostname vault
sudo hostnamectl set-hostname monitoring
```

## Finally, configure Docker to use systemd as the cgroup driver, and set the overlay2 storage driver:


```bash
sudo nano /etc/docker/daemon.json
# Add the following content
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}

sudo systemctl daemon-reload
sudo systemctl restart docker
```

## Initializing the Kubernetes Cluster

The following commands will initialize a Kubernetes cluster on your machine.


```bash
sudo kubeadm init --apiserver-advertise-address=172.20.60.31 --apiserver-bind-port=8080 --pod-network-cidr=10.244.0.0/16
```

This will take some time to complete. After it's done, you should see a message like this:



Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:
```bash
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Alternatively, if you are the root user, you can run:
```bash
  export KUBECONFIG=/etc/kubernetes/admin.conf
```

Then you can join any number of worker nodes by running the following on each as root:
```bash
sudo kubeadm join 172.20.60.31:6443 --token vrh1id.bj0fqreyemhiqb71 \
        --discovery-token-ca-cert-hash sha256:371ef9487feba3d2d9c6434fdc941ada6c17d50652aac9f56d45f0a68a71ccbc
```

Copy and paste the commands to set up your cluster and to join worker nodes as prompted.
Deploying a Pod Network

## Next, you need to deploy a pod network to the cluster. Run the following command:


```bash
sudo kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

This command will deploy a Calico pod network to your cluster.

You can check that the pods are running with the following command:

bash

sudo kubectl get pods -n kube-system -l k8s-app=calico-node

Resetting the Cluster

If you need to reset the Kubernetes cluster, run the following command:


```bash

sudo kubeadm reset
```

This command will revert your machine to its pre-Kubernetes state. You will have to re-run the initialization commands to set up the cluster again.
