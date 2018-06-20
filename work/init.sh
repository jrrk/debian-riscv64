#!/bin/dash
echo Waiting for the sd card ...
sleep 10
echo Mounting the sd partition ...
mount -t ext2 /dev/mmcblk0p2 /mnt || dash
# Mount the /proc and /sys filesystems.
echo Mounting proc
mkdir -p /mnt/proc
mount -t proc none /mnt/proc
echo Mounting sysfs
mkdir -p /mnt/sys
mount -t sysfs none /mnt/sys
echo Mounting devtmpfs
mkdir -p /mnt/dev
mount -t devtmpfs udev /mnt/dev
mkdir -p /mnt/dev/pts
echo Mounting devpts
mount -t devpts devpts /mnt/dev/pts
echo Mounting tmpfs
mkdir -p /mnt/tmp
mount -t tmpfs tmpfs /mnt/tmp
mkdir -p /run
mount -t tmpfs tmpfs /run
# Do your stuff here.
echo "switch_root"
# Boot the real thing.
exec switch_root /mnt /bin/dash
#exec switch_root /mnt /sbin/init
