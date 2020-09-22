#!/usr/bin/env bash
#*************************************
#* Setup and install script for Arch *
#*************************************

echo "**************************************************"
echo "* Setting mirrors for optimal download - Finland *"
echo "**************************************************"

timedatectl set-ntp true
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup # move mirrorlist and make backup

echo "Please enter country: (example Finland(FI), Sweden(SE), United States(US), Germany(GE)...)"
read COUNTRY
reflector --verbose --country ${COUNTRY} --sort rate --save /etc/pacman.d/mirrorlist
