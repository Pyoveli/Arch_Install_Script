#!/usr/bin/env bash

echo "***********************************"
echo "* Bootloader systemd installation *"
echo "***********************************"

bootctl install

mkdir /boot/loader
mkdir /boot/loader/entries

cat <<EOF  > /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options=root=/dev/sda1 rw   		#remeber to change DISKS
EOF

echo "*** Network setup ***"
pacman -S networkmanager dhclient 
systemctl enable --now NetworkManager

echo "*** Set password for Root ***"
echo "Enter password for root: "
passwd root

exit
