rm -fr /boot/*
cp -fr ./new_boot/* /boot/
mv /boot/vmlinuz-lts /boot/vmlinuz-grsec
mv /boot/initramfs-lts /boot/initramfs-grsec

chown -R root /boot
