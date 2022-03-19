# connect wifi
# iwctl --passphrase passphrase station device connect SSID
# update system clock
timedatectl set-ntp true
# partition disk
{
  echo 'mklabel gpt';
  echo 'y';
  echo 'mkpart "EFI system partition" fat32 1MiB 301MiB';
  echo 'set 1 esp on';
  echo 'mkpart "secure partition" ext4 301MiB 100%';
  echo 'quit';
} | parted /dev/sda
# prompt password, setup encrypted partition
echo 'Enter a password to encrypt your installation :';
read PASSWORD
{
  echo 'YES';
  echo $PASSWORD;
  echo $PASSWORD;
} | cryptsetup luksFormat /dev/sda2
# open encrypted partition with password
{
  echo $PASSWORD;
} | cryptsetup open /dev/sda2 cryptlvm
# create fat32 boot partition
mkfs.fat -F 32 /dev/sda1
# create encrypted mapper
pvcreate /dev/mapper/cryptlvm
# CREATE "secure" GROUP
vgcreate secure /dev/mapper/cryptlvm
# CREATE SWAP & FILESYSTEM
lvcreate -L 8G secure -n swap
lvcreate -l 100%FREE secure -n system
# CREATE BTRFS & SUBVOLUMES
mkfs.btrfs /dev/mapper/secure-system
# MOUNT DEVICE MAPPER
mount /dev/mapper/secure-system /mnt
# CREATE BTRFS SUBVOLUMES
btrfs su cr /mnt/@root
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var
btrfs su cr /mnt/@srv
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@swap
btrfs su cr /mnt/@.snapshots
umount /mnt
mount -o noatime,compress=lzo,space_cache,subvol=@root /dev/mapper/secure-system /mnt
mkdir /mnt/{boot,home,var,srv,opt,tmp,swap,.snapshots}
mount -o noatime,compress=lzo,space_cache,subvol=@root /dev/mapper/secure-system /mnt/home
mount -o noatime,compress=lzo,space_cache,subvol=@srv /dev/mapper/secure-system /mnt/srv
mount -o noatime,compress=lzo,space_cache,subvol=@tmp /dev/mapper/secure-system /mnt/tmp
mount -o noatime,compress=lzo,space_cache,subvol=@opt /dev/mapper/secure-system /mnt/opt
mount -o noatime,compress=lzo,space_cache,subvol=@.snapshots /dev/mapper/secure-system /mnt/.snapshots
mount -o nodatacow,subvol=@swap /dev/mapper/secure-system /mnt/swap
mount -o nodatacow,subvol=@var /dev/mapper/secure-system /mnt/var
mount /dev/sda1 /mnt/boot
umount /mnt
pacstrap /mnt base linux linux-firmware vim intel-ucode btrfs-progs
genfstab -U /mnt >> /mnt/etc/fstab
# CHROOT INTO ARCH
arch-chroot /mnt
# SET LOCALES
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
# Run hwclock(8) to generate /etc/adjtime:
hwclock --systohc
# GENERATE LOCALES
locale-gen
# CREATE LOCALES
echo 'LANG=fr_FR.UTF-8' >> /etc/locale.conf
# INSTALL intel-ucode
pacman -S intel-ucode
# replace 
sed -i /etc/mkinitcpio-custom.conf "s/HOOKS=(base udev autodetect block keyboard filesystems fsck)/HOOKS=(base btrfs systemd autodetect modconf keyboard sd-vconsole block sd-encrypt sd-lvm2 filesystems fsck)/g"

