#!/usr/bin/env bash
#*************************************
#* Setup and install script for Arch *
#*************************************

echo "**************************************************"
echo "* Setting mirrors for optimal download - Finland *"
echo "**************************************************\n"

timedatectl set-ntp true
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup # move mirrorlist and make backup

echo "Please enter country: (example Finland(FI), Sweden(SE), United States(US), Germany(GE),...)"
echo "Multiple countries can be selected using commas (e.g. Finland,Germany... or FI,GE...)" 
read COUNTRY
reflector --verbose --latest 5 --country ${COUNTRY} --sort rate --save /etc/pacman.d/mirrorlist

echo -e "\nInstalling prereqs...\n"

echo "*************************"
echo "* Select disk to format *"
echo "*************************"

lsblk

echo "Please enter disk: (example: /dev/sda)"
read DISK
echo -e "\nFormatting disk...\n"

#Preparing disk
sgdisk -Z ${DISK}
sgdisk -2048 -o ${DISK}		# Create new gpt disk 2040 alignment

#Create partitions
sgdisk -n 1:0:+1024M ${DISK}	# Partition 1 (UEFI)
sgdisk -n 2:0:0 ${DISK}		# Partition 2 (Root)

#Set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

#Label partitions
sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

#Make filesystems
echo -e "\nCreating Filesystems...\n"

mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"
mkfs.ext4 -L "ROOT" "${DISK}2"

#Mount targets
mkdir -v /mnt
mount -t ext4 "${DISK}2" /mnt
mkdir -v /mnt/boot
mkdir -v /mnt/boot/efi
mount -t vfat "${DISK}1" /mnt/boot/efi

echo "******************************"
echo "* Arch install on main drive *"
echo "******************************"
pacstrap /mnt base base-devel linux linux-firmware vim nano sudo
genfstab -U /mnt >> /mnt/etc/fstab

cp install_chroot.sh /mnt		# Copy script to /mnt to continue in chroot
arch-chroot /mnt ./install_chroot.sh

rm /mnt/install_chroot.sh		# Remove 2nd install script from /mnt
umount -R /mnt

echo "*** System ready for 1st Boot ***"
