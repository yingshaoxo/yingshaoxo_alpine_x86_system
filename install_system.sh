mv /etc/fstab /fstab

./rsync -av --links ./bin/ /bin/
./rsync -av --links ./etc/ /etc/
./rsync -av --links ./mnt/ /mnt/
./rsync -av --links ./sbin/ /sbin/
./rsync -av --links ./lib/ /lib/
./rsync -av --links ./root/ /root/
./rsync -av --links ./usr/ /usr/
#./rsync -av --links ./home/ /home/
#./rsync -av --links ./run/ /run/
#./rsync -av --links ./sys/ /sys/
#./rsync -av --links ./var/ /var/
#./rsync -av --links ./boot/ /boot/
#./rsync -av --links ./proc/ /proc/
#./rsync -av --links ./tmp/ /tmp/
#./rsync -av --links ./dev/ /dev/
#./rsync -av --links ./swap/ /swap/

mv /fstab /etc/fstab

chown -R root /bin
chown -R root /etc
chown -R root /mnt
chown -R root /sbin
chown -R root /lib
chown -R root /root
chown -R root /usr
