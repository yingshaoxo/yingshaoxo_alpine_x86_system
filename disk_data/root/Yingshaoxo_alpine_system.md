# Yingshaoxo Alpine System
This is a x86 or 32bit or i386 or amd32 archtecture system.

When I create it, the amd64 archtecture computer can also use it.

This system has gcc,python3.10,vim,wget,tmux,bash,ffmpeg,ssh_service built_in, can work in offline.

> **I just want to say, why a simple file and folder copy and paste, has to be done by 100+ steps? Where is the problem with system installation? Why they make it so complecated? If I can create my own computer hardware, I will make the system modification as simple as insert the disk, copy all those files and folders in, done. 2 Steps.**


## How to install
1. Use "alpine_3.0.5_x86_setup-alpine.iso" file to do an offline install first by typing "setup-alpine", then copy and paste some folders under "./disk_data" to root folder of your system by using "./install_system.sh" (You should know how to mount a USB storage to a folder, then in that folder use rsync to do a copy.)
2. Use "alpine_3.0.5_x86_setup-alpine.iso" file to do normal offline install first. then create a iso file or CD for "./disk_data", mount that iso file or CD in "/media/cdrom", run "./install_system.sh".
3. Use "alpine_3.0.5_x86_setup-alpine.iso" to do offline install first. then in another disk partition, install another linux system that will generate boot menu and also work as a PE. In another linux system, copy "disk_data/*" folder to your alpine root folder based on rules in "./install_system.sh".
4. Use virtualbox: just use vdi file directly if you can install virtualbox (You can also convert "./disk_data" to an iso file, then give it to virtualbox, then in your alpine system, you mount and use script to copy those files. **Virtualbox should let user be able to modify container files in realtime just like FTP or ssh or mount without installing any extensions**)
5. Use chroot or mount if you know how to do it, I don't know. (script "./install_system.sh" may help you to figure out how)


## How to install the original alpine system?
1. boot your machine with "alpine_3.0.5_x86_setup-alpine.iso"
2. run `setup-alpine`
3. manually modify network to add "iface eth0 inet dhcp" (if you don't know how to use vi, you can just hit enter)
4. use "done" whtn set apk mirror
5. set NTP as "none"
6. select a disk partition as "sys"
7. reboot, password is "root"


## How to install yingshaoxo alpine system?
### Method 1
copy "disk_data/" folder into your usb storage.

mount your usb driver with: `ls /dev & mount /dev/sda2 /media`

copy everything in disk_data to root folder: `cd /media/disk_data && ./install_system.sh`. 

`reboot`

> Install script is based on rsync, but only do a copy is not enough, you have to use chmod to modify permission to root for all files later. I did that in script.

> If you can make "./disk_data" folder iso file by using `sudo mkisofs -R -J -o disk_data.iso disk_data/`, you can also mount iso file by `mount -t iso9660 /dev/cdrom /media/cdrom`, `cd /media/cdrom && ./install_system.sh`

> If you hit error, you probabally need to copy folders one by one according to "./install_system.sh" script


### Method 2, in LAN, if you have 'tar'
serve "disk_data.tar" file under "http://192.168.x.x:8080/disk_data.tar":
```
tar cf disk_data.tar ./disk_data
python3 -m http.server
```

in your alpine, use "wget" to download that file, then uncompress:
```
wget http://192.168.x.x:8080/disk_data.tar
tar xf disk_data.tar
```

copy all files into your root folder:
```
cd disk_data
./install_system.sh
```


## Password
user: root
password: root


## How to start ssh service?
`service sshd start`


## How I modifyed alpine?

### Enable network
vi /etc/network/interfaces
```
auto eth0
iface eth0 inet dhcp
reboot
```

### Set mirror
vi /etc/apk/repositories
```
http://dl-cdn.alpinelinux.org/alpine/v3.0/main/
#http://mirrors.sjtug.sjtu.edu.cn/alpine/v3.0/main/
```

### Add software
apk update

apk add musl-dev
apk add build-base
apk add linux-headers
apk add bash
apk add wget
apk add python
apk add vim
apk add ffmpeg
apk add tmux
apk add openssh

### Enable ssh service
vim /etc/ssh/sshd_config
```
Port 22
ListenAddress 0.0.0.0
PasswordAuthentication yes
```
service sshd status
service sshd start

### Add yingshaoxo python3.10
https://gitlab.com/yingshaoxo/use_docker_to_build_static_python3_binary_executable

### Shrink vdi file
dd if=/dev/zero of=/var/dummy bs=8126k
rm /var/dummy
VBoxManage modifymedium disk ./alpine_x86.vdi -compact

### Convert virtualbox vdi to img
VBoxManage internalcommands converttoraw alpine_x86.vdi alpine_x86.img


## Prevent data lose
I would suggest you to use another disk as home folder, you do the home mount when system init by using crontab.
