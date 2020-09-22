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
read DISK
echo -e "\nFormatting disk...\n"

#Preparing disk
sgdisk -Z ${DISK}
sgdisk -2048 -o ${DISK}		# Create new gpt disk 2040 alignment

#Create partitions
sgdisk -n 1:0:+1G ${DISK}	# Partition 1 (UEFI)
sgdisk -a 2048 -o ${DISK}	# Partition 2 (Root)

#Set partition types
sgdisk -t 1:ef00 ${DISK}
sgdisk -t 2:8300 ${DISK}

#Label partitions
sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}
#
