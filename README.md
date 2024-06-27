# Yingshaoxo Alpine System
This is a x86 or 32bit or i386 or amd32 archtecture system.

When I create it, the amd64 archtecture computer can also use it.

This system has `gcc,python3.10,vim,wget,tmux,bash,ffmpeg,ssh_service` built_in, can work in offline.

> I just want to say, why a simple file and folder copy and paste, has to be done by 100+ steps? Where is the problem with system installation? Why they make it so complecated? If I can create my own computer hardware, I will make the system modification as simple as insert the disk, copy all those files and folders in, done. 2 Steps.

> **According to my experience, each time when they created some new computer type, they will force abandon old systems, they will let you unable to install old systems. But unfortunately, old system has more freedom. As for security, what kind of hacker can hack in a computer that does not have internet?**

> In the end, for all software in manufacturer level, they simply do disk copy, who would waste time to install system manually one by one for millions of devices in factory?


## How to install?
1. Get an old computer that supports "MBR parition and BIOS boot_loading", normally it was created before 2010 years. Use "alpine_3.0.5_x86_setup-alpine.iso" file to do an offline install first by typing "setup-alpine". You may need to use "rufus" to make a bootable USB driver because the official alpine does not have boot software in their iso file, I hate that. Then copy and paste some folders under "./disk_data" to root folder of your system by using "./install_system.sh" (You should know how to mount a USB storage to a folder, then in that folder use rsync to do a copy.)
2. Use "alpine_3.0.5_x86_setup-alpine.iso" file to do normal offline install first. then create a iso file or CD for "./disk_data", mount that iso file or CD to "/media/cdrom", run "./install_system.sh".
3. Use "alpine_3.0.5_x86_setup-alpine.iso" to do offline install first. then in another disk partition, install another linux system that will generate boot menu and also work as a PE. In another linux system, copy "disk_data/*" folder to your alpine root folder based on rules in "./install_system.sh".
4. Or use virtualbox: just use vdi file directly if you can install virtualbox (You can also convert "./disk_data" to an iso file, then give it to virtualbox, then in your alpine system, you mount and use script to copy those files. **Virtualbox should let user be able to modify container files in realtime just like FTP or ssh or mount without installing any extensions**)
5. Or use chroot or mount if you know how to do it, I don't know. (script "./install_system.sh" may help you to figure out how)

> Virtualbox container: https://www.mediafire.com/file/54zdwsz4exbheq4/yingshaoxo_alpine_x86_system_virtualbox_2024_6_21.7z/file

> When use win_xp virtualbox, you have to `turn off vt-x and amd-v`, you have to manually add vdi as disk, you have to set linux type to 'other 32bit type linux'. You have to make sure cpu core is 1, but in real computer, this alpine version supports 2 core cpu, in old computer.


## How to install the original alpine system?
0. go to "alpine_3.0.5_x86_setup-alpine", run `./merge_to_get_real_iso_file.sh`. (It uses "cat alpine_3.0.5_x86_setup-alpine.0* > alpine_3.0.5_x86_setup-alpine_test.iso")
1. use "rufus" to install that iso file to your 1GB usb driver
2. boot your machine with "alpine_3.0.5_x86_setup-alpine.iso"
3. run `setup-alpine`
4. manually modify network to add "iface eth0 inet dhcp" (if you don't know how to use vi, you can just hit enter)
5. use "done" when set apk mirror
6. set NTP as "none"
7. select a disk partition as "sys"
8. reboot, username and password is "root"

> They actually provides some local apk packages for you to install in their iso file, in /media/cdrom/apk/x86 or /media/usb, you can install them by "apk add ./xx.apk"

> I would suggest you papare 2 disk, one 10GB for system, one 1TB for your home data. Because this version of alpine does not support install to a partition, it will erase the whole disk.

> Ubuntu8 only support ext2 disk format, but this alpine version supports ext4. I'm not saying newer is better, just a tip for you to install ubuntu8.


## How to install the hardware_bootable_alpine_3.0.5_x86 version?
1. go to "hardware_bootable_alpine_3.0.5_x86" folder, run "./merge_to_get_real_iso_file.sh". (Virtualbox does not support this version, this only works for real hardware x86 old computer. You will need to use `tar -xzf **.tar.gz` to get iso file. You will need to use dd to copy the whole iso file into your 8GB USB driver to create a boot USB, `dd if=**.iso of=/dev/sdb`)
2. boot your machine with "alpine_3.0.5_x86_setup-alpine.iso"
3. do the installation as above section "install the original alpine sytem"


## How to install the alpine in a single disk partition by doing disk partition copy and fix the boot menu?
1. copy your old alpine system partition as a iso file, here my version is `./disk_data/`, especially make sure the `/boot` folder has files: `vmlinuxz-grsec` and `initramfs-grsec`. `dd if=/dev/sdb2 of=xx.iso`. (also do `chown -R root /` to make all files in that partition belongs to root permission)
2. use dd to copy that disk partiton to your new computer partition, a ext4 would be fine. `dd if=xx.iso of=/dev/sdb2`
3. i am using `lubuntu16_i386` system to work as a PE system, all you have to do is install lubuntu16_i386 to another partition of your disk. It will generate a not working version of grub boot menu for you, you can see "unknown linux distrubution" when you boot your computer. you need to fix it later.
4. boot into lubuntu16, `sudo su`, `vim /etc/grub.d/40_custom`, add following to the bottom:
    ```
    menuentry 'Alpine' {
        insmod part_msdos
        insmod ext2
        set root='hd0,msdos5'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos5 --hint-efi=hd0,msdos5 --hint-baremetal=ahci0,msdos5  b22f8c27-ad74-4b25-a219-7c5a8d876451
        else
          search --no-floppy --fs-uuid --set=root b22f8c27-ad74-4b25-a219-7c5a8d876451
        fi
        linux /boot/vmlinuz-grsec root=/dev/sda5 rootfstype=ext4 modules=sd-mod,usb-storage,ext4
        initrd '/boot/initramfs-grsec'
    }
    ```

5. you can change the `40_custom` based on `/boot/grub/grub.cfg`, I just did a copy and modify from "Unknown Linux distribution" boot menu. You just have to make sure the disk partiton position and uuid is right. (use `blkid` to see uuid of partitions)
6. after the modification, run `sudo update-grub`, it will update the real boot menu. (Sometimes you should also run `sudo grub-install /dev/xx` for all of your disks.)

> alpine says their system support new boot method, for example EFI, but I don't know how to config it: https://wiki.alpinelinux.org/wiki/Bootloaders

> if you can't see unknow distrubution, change 40_custom to something like this `menuentry 'Alpline' {\nset root='hd0,msdos5'\nlinux /boot/vmlinuz-grsec root=/dev/sda5\ninitrd '/boot/initramfs-grsec''`, run `update-grub`.

> lubuntu16 has gparted when you boot from usb, in there you can see your disk name and partition name in a clear way. But they will uninstall it after you install lubuntu16, what a stupid idea!

> `/boot` folder basically manages all stuff related to your machine boot issue, when you do a partition copy and paste, you have to make sure something is inside of that folder.

> if `/boot` not work on your computer, try `/new_boot` by doing rename

### If you have ubuntu14, you can also use their /boot folder for newer amd64 computer that only support efi

copy `./_new_boot2014_/*` into your alpine `/boot/` folder, then change boot menu `/etc/grub.d/40_custom`:

```
menuentry 'Alpine Linux 3.0 based on ubuntu14 boot' {
	insmod part_gpt
	insmod part_msdos
	insmod ext2
	search --no-floppy --fs-uuid --set=root 0f2b91c3-fb66-4d58-852c-57f1fcb31604
	linux /_new_boot2014_/vmlinuz-4.4.0-142-generic.efi.signed root=UUID=0f2b91c3-fb66-4d58-852c-57f1fcb31604 ro intel_pstate=enable
	initrd /_new_boot2014_/initrd.img-4.4.0-142-generic

}
```

> If you have ubuntu8-server, in ubuntu8, you can even do offline install for gcc,php5,mysql-server by using `apt-cdrom add /dev/cdrom` and `apt-get install build-essential`.


## How to install yingshaoxo alpine system?
### Method 1
copy "disk_data/" folder into your usb storage.

mount your usb driver with: `ls /dev & mount /dev/sda2 /media`

copy everything in disk_data to root folder: `cd /media/disk_data && ./install_system.sh`. 

`reboot`

> Install script is based on rsync, but only do a copy is not enough, you have to use chmod to modify permission to root for all files later. I did that in script.

> If you can make "./disk_data" folder iso file by using `sudo mkisofs -R -J -o disk_data.iso disk_data/`, you can also mount iso file by `mount -t iso9660 /dev/cdrom /media/cdrom`, `cd /media/cdrom && ./install_system.sh`

> If you hit error, you probabally need to copy folders one by one according to "./install_system.sh" script

> Mount type after "mount -t" can be "fat, vfat, adfs, affs, autofs, cifs, coda, coherent, cramfs, debugfs, devpts, efs, ext, ext2, ext3, ext4, hfs, hfsplus, hpfs, iso9660, jfs, minix, msdos, ncpfs, nfs,  nfs4,  ntfs,  proc, ncpfs". Normally you will only use `fat, vfat, msdos, ext2, ext4, ntfs, iso9660`.


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

#auto wlan0
#allow-hotplug wlan0
#iface wlan0 inet dhcp
#wpa-ssid "your_wifi_name"
#wpa-psk "your_wifi_password"
```

reboot

### Set mirror
vi /etc/apk/repositories
```
http://dl-cdn.alpinelinux.org/alpine/v3.0/main/
#http://mirrors.sjtug.sjtu.edu.cn/alpine/v3.0/main/
```

### Add software
```
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
```

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
```
dd if=/dev/zero of=/var/dummy bs=8126k
rm /var/dummy
VBoxManage modifymedium disk ./alpine_x86.vdi -compact
```

### Convert virtualbox vdi to img
VBoxManage internalcommands converttoraw alpine_x86.vdi alpine_x86.img


## Prevent data lose
I would suggest you to use another disk as home folder, you do the home mount when system init by using crontab.
