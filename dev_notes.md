# Note for dev the iso file

When I tried to extract files from virtualbox, it really takes me a lot of thinking about how.

When I use virtualbox in linux, I could not let inner container get the host usb devices, that is a big problem. (But in windows xp old virtualbox version, everything is working fine)

## How to extract the system partition from virtualbox?

You can directly convert vdi file to iso file, but that iso is for the whole disk, not a partition.

So what I did is use dd command.

I first created a new 2GB vdi file, then use "lubuntu-16.04.6-desktop-i386.iso" to work as a PE system, because lubuntu has the gparted inside, so that I could have a look at those disk and partition, and maybe do a resize for a partition to make the final iso file smaller. (You may not be able to get "lubuntu-16.04.6-desktop-i386.iso" from public network any more, but I have one, old is good. The lubuntu requires 'Enable PAE/NX' on in virtualbox, and 2 core cpu. Alpine will only work on 1 core cpu in virtualbox, but in real old computer, it supports 2 core cpu.)

First what I did is to copy the alpline partion to new vdi disk by using dd: `dd if=/dev/sda<source_partition> of=/dev/sdb<target_partition> bs=1M`

Then in the new vdi disk, I have a copy of alpline. For some unknown reason, I could not resize the old alpline partition, but in new vdi disk, I could do a resize to let the final partition less than 900MB.

But we are not done yet. We need to convert that partition to a iso file, so that in a new computer, we could directly paste that iso file as a disk partition.

How to convert a disk partition to iso file? `dd if=/dev/sdb<source_partition> of=/media/another_disk/my_alpine.iso` (Opps, it seems like we have to create another vdi file or partition to save that iso file after mounting it. You can mount a disk by using `mdkir -p /media/another_disk && mount -t ext4 /dev/sdb2 /media/another_disk`)

After we have copied a alpline partition as iso file in virtualbox, we should export it. The virtualbox does not allow you to directly do it without extention, that is their problem. How to solve it? We servce that iso file with HTTP protocol, then we download it in HOST computer. We can use "Tools serve 9999" to do it, then we download that file by visit "http://192.168.xx.xx:9999/my_alpine.iso". Or we could serve that iso file by using "python2 -m SimpleHTTPServer 9999".

I did the whole thing in my virtualbox version, in new version, things may change, as they always do. So you can use a never upgrade virtualbox version in windows xp system. The version code is "4.2.0". You have to set up a global real fire wall to disallow every output network for your system first. Because as I know, the current linux firewall is a fake one, it only disable input network, which is useless.

After copy the partition to a new computer, you need to install "lubuntu16" in another partition to fix the boot menu, so you can choose to go to alpline.

> By the way, if you just copy the disk to a new disk as a whole, then if your new computer has the same boot logic, you should directly have a bootable system. But unfortunately, new computer are garbage, they will change boot logic.

## How I made the bootable iso file? Because the original iso file is not bootable.

1. I first use "rufus" to created a bootable USB from original alpline iso file
2. I use dd to copy my usb driver to iso file, then do a compression
3. It is not working in virtualbox but work in real world old computer

<!--
2. Then I just "disk genius" to resize the cdrom partition size, make it smaller
3. I created a ext2 partition for user to hold new data in yingshaoxo system, so they can install yingshaoxo_system directly later
3. Then I mounted that cdrom folder into my linux computer, then use command to get iso bootable file: `genisoimage -o /home/yingshaoxo/CS/yingshaoxo_alpine_x86_system/bootable.iso -R -J -l -v -V "yingshaoxo_alpine" -hide-rr-moved -b boot/syslinux/isolinux.bin -c boot/syslinux/boot.cat -no-emul-boot -boot-load-size 4 -pad /media/cdrom`

> People also use "mkisofs -o my.iso -b /isolinux/isolinux.bin -c /isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table directorycontents" to make bootable iso file time to time.
-->
