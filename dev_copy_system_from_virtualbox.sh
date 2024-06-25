# virtualbox can't export iso file that could get directly mount by linux, fuck
# actually, if i'm the author of virtualbox, I could even let you be able to do virtualbox file edition in real time, just like ftp. No need for installing any extension bullshit.

#scp -r root@192.168.2.107:/* ./disk_data/

mkdir ./disk_data
rsync -av root@192.168.2.107:/ ./disk_data/
#rsync -av root@192.168.2.107:/bin/ ./disk_data/bin/
#rsync -av root@192.168.2.107:/etc/ ./disk_data/etc/
#rsync -av root@192.168.2.107:/mnt/ ./disk_data/mnt/
#rsync -av root@192.168.2.107:/sbin/ ./disk_data/sbin/
#rsync -av root@192.168.2.107:/lib/ ./disk_data/lib/
#rsync -av root@192.168.2.107:/usr/ ./disk_data/usr/
#rsync -av root@192.168.2.107:/root/ ./disk_data/root/
#rsync -av root@192.168.2.107:/boot/ ./disk_data/boot/

cp ./rsync ./disk_data/
cp ./install_system.sh ./disk_data/

#sudo apt install mkisofs
#sudo mkisofs -R -J -o disk_data.iso disk_data/
#VBoxManage convertfromraw disk_data.iso disk_data.vdi
