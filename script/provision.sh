#! /bin/bash
set -ex

echo 'ubuntu' > /etc/hostname
echo root:root | chpasswd

cat <<EOF > /etc/netplan/99_config.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: true
      nameservers:
       addresses: [114.114.114.114,8.8.8.8]
EOF

netplan generate

sed -i '/security.ubuntu.com/d' /etc/apt/sources.list

apt-get update