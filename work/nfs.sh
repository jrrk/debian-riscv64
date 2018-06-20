#!/bin/dash
ifconfig eth0 192.168.0.51 up
rdate -s 192.168.0.53
mount -t nfs -o nolock 192.168.0.53:/mnt/nfs /nfs
# Mount the /proc and /sys filesystems.
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
exec switch_root /nfs /bin/dash
#exec switch_root /nfs /sbin/init
