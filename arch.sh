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