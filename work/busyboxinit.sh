#!/bin/busybox ash
/bin/busybox --install -s
dd if=/dev/gpio0 of=/tmp/sw count=1
SW=`cat /tmp/sw`
echo -n $SW > /dev/gpio0
mkdir /dos
case $SW in
    ??0?)
        sleep 2
        echo Mounting SD root
        mount -t ext4 /dev/mmcblk0p2 /mnt || (echo Mount failed, dropping to ash; /bin/ash)
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
        mkdir -p /mnt/run
        mount -t tmpfs tmpfs /mnt/run
        echo Executing switch_root for mmc
        exec switch_root /mnt /sbin/init
        ;;
    ??1?)
        mount -t proc none /proc
        udhcpc -s /usr/share/udhcpc/default.script
        rdate -s 132.163.97.4 # This should be replaced by a local server
        echo Mounting NFS root
        mount.nfs -o nolock 128.232.65.94:/mnt/nfs2 /nfs 
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
        umount /proc
        echo Executing switch_root for nfs
        exec switch_root /nfs /sbin/init
        ;;
    ??2? | ??3? | ??4? | ??5? | ??6? | ??7? | ??8? | ??9? | ??A? | ??B? | ??C? | ??D? | ??E? | ??F? )
        sleep 2
        echo Mounting SD /dos
	mkdir -p /dos
        mount -t msdos /dev/mmcblk0p1 /dos
	touch /dos/$SW.sh
	. /dos/$SW.sh
	echo Boot selection $SW not executed, dropping to ash
	/bin/ash -i
        umount /dos
	;;
esac
