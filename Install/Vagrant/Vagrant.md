# Vagrant File Explanation

This README provides an explanation of the Vagrant file included in this repository. The Vagrant file is used to define and configure a multi-node virtual environment for testing and experimenting with Kubernetes. Let's go through each section and configuration option to understand its purpose and functionality.

## Define the number of worker nodes

```ruby
num_workers = 2
```

The variable `num_workers` specifies the number of worker nodes you want to create in your Kubernetes cluster. In this example, there are two worker nodes, but you can adjust this value based on your requirements.

## Vagrant Configuration

```ruby
Vagrant.configure("2") do |config|
```

This block starts the Vagrant configuration. The `"2"` parameter indicates that this configuration is for Vagrant version 2.

### Set the box to use

```ruby
config.vm.box = "debian/bullseye64"
```

This line sets the base box to be used for the virtual machines. In this case, we are using the "debian/bullseye64" box, which is a Debian-based operating system.

### Configure the provider

```ruby
config.vm.provider "virtualbox" do |vb|
  vb.memory = 2048
  vb.cpus = 2
end
```

This block configures the virtualization provider, which in this case is VirtualBox. It specifies the memory and CPU settings for the virtual machines. Each virtual machine will have 2048 MB of memory and 2 CPUs.

### Define the master node

```ruby
config.vm.define "master" do |node|
  node.vm.hostname = "master"
  node.vm.network "private_network", ip: "192.168.56.10"
  
  # Provision the master node
  # ...
end
```

This block defines the configuration for the master node. The `node.vm.hostname` option sets the hostname of the virtual machine to "master". The `node.vm.network` option configures a private network interface with a specified IP address. In this case, the master node has an IP address of "192.168.56.10".

Inside this block, there are several provisioning steps defined using the `config.vm.provision` directive. These steps are executed during the provisioning process of the virtual machine. Each step runs a shell script located in the "script" directory.

### Define the worker nodes

```ruby
num_workers.times do |i|
  config.vm.define "worker-#{i}" do |node|
    node.vm.hostname = "worker-#{i}"
    node.vm.network "private_network", ip: "192.168.56.#{10 + i}"
    
    # Provision the worker node
    # ...
  end
end
```

This block defines the configuration for the worker nodes. The `num_workers.times` loop creates the specified number of worker nodes. Each worker node is assigned a unique hostname and IP address.

Similar to the master node, the worker nodes have provisioning steps defined inside their respective blocks.

## Provisioning Steps

The provisioning steps defined in the Vagrant file execute shell scripts located in the "script" directory. These scripts are responsible for setting up and configuring the environment on the respective virtual machines.

The provisioning steps include:

- `install-essential-tools`: Installs essential tools required for the Kubernetes setup.
- `allow-bridge-nf-traffic`: Enables the forwarding of network traffic.
- `install-containerd`: Installs the container runtime.
- `install-kubeadm`: Installs the Kubernetes administration tool.
- `update-kubelet-config`: Updates the kubelet configuration with the specified network interface.
- `launch-vault`: Launches the Vault service.
- `init