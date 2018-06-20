#!/bin/busybox ash
/bin/busybox --install -s
rm /bin/switch_root
ifconfig eth0 192.168.0.51 up
rdate -s 192.168.0.53
mount -t proc none /proc
echo Mounting NFS root
mount.nfs 192.168.0.53:/mnt/nfs /nfs
echo Mounting proc
mkdir -p /nfs/proc
mount -t proc none /nfs/proc
echo Mounting sysfs
mkdir -p /nfs/sys
mount -t sysfs none /nfs/sys
echo Mounting devtmpfs
mkdir -p /nfs/dev
mount -t devtmpfs udev /nfs/dev
mkdir -p /nfs/dev/pts
echo Mounting devpts
mount -t devpts devpts /nfs/dev/pts
echo Mounting tmpfs
mkdir -p /nfs/tmp
mount -t tmpfs tmpfs /nfs/tmp
mkdir -p /run
mount -t tmpfs tmpfs /run
#echo exit shell to run switch_root
#busybox ash
umount /proc
#exec switch_root /nfs /usr/sbin/dropbear
#exec switch_root /nfs /sbin/init
exec switch_root /nfs /bin/dash
