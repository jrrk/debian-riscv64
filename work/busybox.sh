#!/bin/busybox ash
/bin/busybox --install -s
mount -t proc none /proc
udhcpc -s /usr/share/udhcpc/default.script
rdate -s 132.163.97.4 # This should be replaced by a local server
echo Mounting NFS root
mount.nfs 128.232.65.94:/mnt/nfs /nfs
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
exec switch_root /nfs /sbin/init
#exec switch_root /nfs /bin/dash
