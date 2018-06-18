export CHROOT_PATH=/mnt/debian

dd if=/dev/zero of=cardmem.bin bs=2M count=2047
echo ' # partition table of image\' \
     'unit: sectors\' \
     '\' \
     '   image1 : start=     2048, size=  8382464, Id=83, bootable\' \
     '   image2 : start=        0, size=        0, Id= 0\' \
     '   image3 : start=        0, size=        0, Id= 0\' \
     '   image4 : start=        0, size=        0, Id= 0\' \
    | tr '\\' '\012' | sed 's=^\ ==' | tee $@.log | /sbin/sfdisk -f cardmem.bin

LOOP=`sudo losetup -o 1048576 --show -f cardmem.bin`
echo Loop device is $LOOP
sudo mkfs.ext2 $LOOP
sudo mkdir -p ${CHROOT_PATH}
sudo mount -t ext2 $LOOP ${CHROOT_PATH}
sudo multistrap --no-auth -d ${CHROOT_PATH} -f multistrap-riscv64.conf

sudo sh -c "cat >${CHROOT_PATH}/etc/fstab <<EOF
proc    /proc   proc    defaults        0       0
sysfs   /sys    sysfs   defaults,nofail 0       0
devpts  /dev/pts        devpts  defaults,nofail 0       0
EOF
"

sudo sh -c "cat >${CHROOT_PATH}/etc/network/interfaces <<EOF
source-directory /etc/network/interfaces.d
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
EOF
"

sudo mknod -m 666 "${CHROOT_PATH}/dev/null" c 1 3
sudo mknod -m 666 "${CHROOT_PATH}/dev/zero" c 1 5
sudo mknod -m 666 "${CHROOT_PATH}/dev/random" c 1 8
sudo mknod -m 666 "${CHROOT_PATH}/dev/urandom" c 1 9
sudo mknod -m 666 "${CHROOT_PATH}/dev/tty" c 5 0
sudo mknod -m 666 "${CHROOT_PATH}/dev/ptmx" c 5 2
sudo mknod -m 666 "${CHROOT_PATH}/dev/full" c 1 7
sudo mknod -m 600 "${CHROOT_PATH}/dev/console" c 5 1
sudo mknod -m 660 "${CHROOT_PATH}/dev/ttyS0" c 4 64
sudo mkdir -p "${CHROOT_PATH}/dev/pts/"
sudo mkdir -p "${CHROOT_PATH}/dev/shm/"
#sudo mknod -m 666 "${CHROOT_PATH}/dev/ptmx" c 5 2
sudo ln -s /proc/self/fd   "${CHROOT_PATH}/dev/fd"
sudo ln -s /proc/self/fd/0 "${CHROOT_PATH}/dev/stdin"
sudo ln -s /proc/self/fd/1 "${CHROOT_PATH}/dev/stdout"
sudo ln -s /proc/self/fd/2 "${CHROOT_PATH}/dev/stderr"
#Get access
sudo sh -c "sed -e 's=compat=files=' < ${CHROOT_PATH}/usr/share/libc-bin/nsswitch.conf > ${CHROOT_PATH}/etc/nsswitch.conf"
sudo sh -c "sed -e 's=sbin/sulogin=bin/dash=' -e 's=2:initdef=S:initdef=' -e 's=tty1=console=' < ${CHROOT_PATH}/usr/share/sysvinit/inittab > ${CHROOT_PATH}/etc/inittab"
sudo cp -p ${CHROOT_PATH}/usr/share/base-passwd/passwd.master ${CHROOT_PATH}/etc/passwd
sudo cp -p ${CHROOT_PATH}/usr/share/base-passwd/group.master ${CHROOT_PATH}/etc/group

rm -fr ramfs
mkdir ramfs
cd ramfs
mkdir -p bin etc dev home lib proc sbin sys tmp usr mnt nfs root run usr/bin usr/lib usr/sbin usr/share/perl5 lib/riscv64-linux-gnu usr/lib/riscv64-linux-gnu # usr/share/sysvinit
cp -p ${CHROOT_PATH}/bin/bash-static ./bin
cp -p ${CHROOT_PATH}/sbin/ifconfig ./sbin
cp -p ${CHROOT_PATH}/sbin/switch_root ./sbin
cp -p ${CHROOT_PATH}/bin/mount ./bin
cp -p ${CHROOT_PATH}/bin/mkdir ./bin
cp -p ${CHROOT_PATH}/bin/sleep ./bin
cp -p ${CHROOT_PATH}/usr/share/base-passwd/passwd.master ./etc/passwd
cp -p ${CHROOT_PATH}/usr/share/base-passwd/group.master ./etc/group
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libc.so.6 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libm.so.6 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libz.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libbz2.so.1.0 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libfdisk.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libsmartcols.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libnss_files.so.2 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libdl.so.2 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/librt.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libaudit.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libcap.so.2 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libcap-ng.so.0 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libidn.so.11 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libresolv.so.2 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libsepol.so.1 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libuuid.so.1 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libpcre.so.3 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libtinfo.so.5 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libblkid.so.1 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libmount.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libcrypt.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libcom_err.so.2 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libselinux.so.1 ./lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libpthread.so.0 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libkeyutils.so.1 ./lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libsemanage.so.1 ./usr/lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libgssapi_krb5.so.2 ./usr/lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libcrypto.so.1.0.2 ./usr/lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libpcap.so.0.8 ./usr/lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libnettle.so.6 ./usr/lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libkrb5.so.3 ./usr/lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libk5crypto.so.3 ./usr/lib/riscv64-linux-gnu
#cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libkrb5support.so.0 ./usr/lib/riscv64-linux-gnu
cp -p ${CHROOT_PATH}/lib/ld-linux-riscv64-lp64d.so.1 ./lib
#cp -pr ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/perl-base ./usr/lib/riscv64-linux-gnu
#cp -pr ${CHROOT_PATH}/usr/share/perl5/Debian ./usr/share/perl5
cat > init <<EOF
#!/bin/bash-static
echo Exit shell when ready to switch_root
/bin/bash-static -i
ifconfig eth0 192.168.0.51 up
echo Waiting for the sd card ...
sleep 10
echo Mounting the sd partition ...
mount -t ext2 /dev/mmcblk0p1 /mnt || dash
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
exec switch_root /mnt /bin/bash-static
#exec switch_root /mnt /sbin/init
EOF
chmod +x init
#mv init{,rc}
#ln -s /bin/bash init
echo "\
        mknod dev/null c 1 3 && \
        mknod dev/tty c 5 0 && \
        mknod dev/zero c 1 5 && \
        mknod dev/console c 5 1 && \
        mknod dev/random c 1 8 && \
        mknod dev/urandom c 1 9 && \
        mknod dev/mmcblk0 b 179 0 && \
        mknod dev/mmcblk0p1 b 179 1 && \
        mknod dev/mmcblk0p2 b 179 2 && \
        find . | cpio -H newc -o > ../../riscv-linux/initramfs.cpio" | fakeroot

WORK=/local/scratch-legacy/debian
sudo rm -rf $WORK
sudo mkdir -p $WORK
(cd ${CHROOT_PATH}; sudo tar cf - .)|(cd $WORK; sudo tar xf -)
sudo umount ${CHROOT_PATH}
sudo losetup -d $LOOP
