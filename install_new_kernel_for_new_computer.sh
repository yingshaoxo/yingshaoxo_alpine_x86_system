mkdir /boot_backup
cp -fr /boot/* /boot_backup/

rm -fr /boot/*
cp -fr ./new_boot/* /boot/
mv /boot/vmlinuz-lts /boot/vmlinuz-grsec
mv /boot/initramfs-lts /boot/initramfs-grsec

chown -R root /boot
echo "New kernel will not let you 'mount -t vfat /dev/sdb1 /media/usb'"
