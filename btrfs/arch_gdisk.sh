#!/bin/bash
# load keymap
loadkeys fr
# sync network
timedatectl set-ntp true
# partition disk
{
    echo 'n';
    echo '';
    echo '';
    echo '+200M';
    echo 'ef00';
    echo 'n';
    echo '';
    echo '';
    echo '+2G';
    echo '8200';
        echo 'n';
    echo '';
    echo '';
    echo '';
    echo '';
    echo 'w';
    echo 'Y';
} | gdisk /dev/sda
# format efi partition
mkfs.fat -F32 /dev/sda1
# format swap and activate
mkswap /dev/sda2
swapon /dev/sda2
# format btrfs using force flag
mkfs.btrfs /dev/sda3 -f