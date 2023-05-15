
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
