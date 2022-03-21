#!/bin/bash
mount /dev/sda3 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@var
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@srv
btrfs su cr /mnt/@snapshots
umount /mnt
mount -o noatime,compress=lzo,subvol=@ /dev/sda3/ /mnt
mkdir -p /mnt/{boot,home,tmp,var,opt,srv,.snapshots}
mount -o noatime,compress=lzo,subvol=@tmp /dev/sda3/ /mnt/tmp
mount -o noatime,compress=lzo,subvol=@var /dev/sda3/ /mnt/var
mount -o noatime,compress=lzo,subvol=@opt /dev/sda3/ /mnt/opt
mount -o noatime,compress=lzo,subvol=@srv /dev/sda3/ /mnt/srv
mount -o noatime,compress=lzo,subvol=@snapshots /dev/sda3/ /mnt/.snapshots
mount /dev/sda1 /mnt/boot
pacstrap /mnt base linux linux-firmware nano snapper