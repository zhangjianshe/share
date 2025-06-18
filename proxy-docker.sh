#!/bin/bash

set -e

echo ">>> Setting up Docker daemon.json with China mirrors..."

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://registry.aliyuncs.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://registry.docker-cn.com"
  ],
  "dns": ["8.8.8.8", "223.5.5.5"],
  "proxies": {
    "default": {
      "httpProxy": "",
      "httpsProxy": "",
      "noProxy": "localhost,127.0.0.1,.svc,.cluster.local"
    }
  },
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 5,
  "log-level": "warn",
  "experimental": false
}
EOF

echo ">>> Reloading Docker..."

sudo systemctl daemon-reexec
sudo systemctl restart docker
sudo systemctl enable docker

echo ">>> Docker registry mirrors configured."

echo
echo ">>> If you're using kubeadm, you can pull k8s images like this:"
echo "    kubeadm config images pull --image-repository=registry.aliyuncs.com/google_containers"
echo

