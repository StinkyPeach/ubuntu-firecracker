#! /bin/bash
set -ex

rm -rf /output/*

cp /root/linux-source-$KERNEL_SOURCE_VERSION/vmlinux /output/vmlinux
cp /root/linux-source-$KERNEL_SOURCE_VERSION/.config /output/config

truncate -s 2G /output/image.ext4
mkfs.ext4 /output/image.ext4

mount /output/image.ext4 /rootfs
debootstrap --include openssh-server,netplan.io,nano bionic /rootfs http://mirrors.aliyun.com/ubuntu/
mount --bind / /rootfs/mnt

cp -b /etc/apt/sources.list /rootfs/etc/apt/

chroot /rootfs /bin/bash /mnt/script/provision.sh

umount /rootfs/mnt
umount /rootfs

cd /output
tar czvf ubuntu-bionic.tar.gz image.ext4 vmlinux config
cd /