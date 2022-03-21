#!/bin/bash
# format efi partition
mkfs.fat -F32 /dev/sda1
# format swap and activate
mkswap /dev/sda2
swapon /dev/sda2
# format btrfs using force flag
mkfs.btrfs /dev/sda3 -f
# mount our disk on /mnt = root directory
mount /dev/sda3 /mnt
# create btrfs subvolumes
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@var
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@srv
btrfs su cr /mnt/@snapshots
# unmount /mnt
umount /mnt
# mount /mnt to @ root subvolume
mount -o noatime,compress=lzo,subvol=@ /dev/sda3/ /mnt
# create subvolumes directories
mkdir -p /mnt/{boot,home,tmp,var,opt,srv,.snapshots}
# mount subvolumes
mount -o noatime,compress=lzo,subvol=@tmp /dev/sda3 /mnt/tmp
mount -o noatime,compress=lzo,subvol=@var /dev/sda3 /mnt/var
mount -o noatime,compress=lzo,subvol=@opt /dev/sda3 /mnt/opt
mount -o noatime,compress=lzo,subvol=@srv /dev/sda3 /mnt/srv
mount -o noatime,compress=lzo,subvol=@snapshots /dev/sda3/ /mnt/.snapshots
# mount efi partition
mount /dev/sda1 /mnt/boot