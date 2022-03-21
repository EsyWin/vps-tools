#!/bin/bash
# load keymap
loadkeys fr
# sync network
timedatectl set-ntp true
# install git
pacman -S git
# partitionning
curl https://raw.githubusercontent.com/esywin/vps-tools/main/btrfs/utils/gdisk.sh | bash
# btrfs formatting
curl https://raw.githubusercontent.com/esywin/vps-tools/main/btrfs/utils/btrfs.sh | bash
# sync pacman
pacman -Syyy
# install base packages
pacstrap /mnt base linux linux-firmware nano snapper curl git reflector btrfs-progs grub grub-btrfs -y
# genfstab
genfstab -U /mnt >> /mnt/etc/fstab
# chroot into new system
echo "type  'arch-chroot /mnt' to continue"