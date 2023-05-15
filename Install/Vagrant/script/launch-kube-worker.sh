# Setup for Node servers

set -euxo pipefail

config_path="/vagrant/configs"

/bin/bash $config_path/join.sh -v

sudo -i -u debian bash << EOF
whoami
mkdir -p /home/debian/.kube
sudo cp -i $config_path/config /home/debian/.kube/
sudo chown 1000:1000 /home/debian/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker
EOF

