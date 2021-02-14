root_drive=/dev/sda5
home_drive=/dev/sdb1
boot_drive=/dev/sda1
rootlvm=debian-vg

# keyboard und konsole einrichten
echo "Configure console..."
sudo dpkg-reconfigure keyboard-configuration
sudo dpkg-reconfigure console-setup

# programme installieren
echo "Install necessary packages..."
sudo apt install vim lvm2 cryptsetup btrfs-progs

# Laufwerke einbinden
echo "Mounting drives..."
cryptsetup open $rootdrive debian_crypt
cryptsetup open $homedrive home_crypt

sudo mount -o rw,noatime,compress=zstd /dev/$rootlvm/root /mnt
sudo mount -o rw,noatime,compress=zstd /dev/mapper/home_crypt /mnt/home
sudo mount $boot_drive /mnt/debian/boot

# in chroot wechseln
echo "Chrooting ..."
for i in dev dev/pts proc sys; do sudo mount -o bind /$i /mnt/debian/$i; done

sudo chroot /mnt/debian
