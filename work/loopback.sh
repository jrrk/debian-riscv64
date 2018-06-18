LOOPBACK_PATH=/mnt/debian
LOOP=`sudo losetup -o 1048576 --show -f cardmem.bin`
echo Loop device is $LOOP
sudo mkfs.ext2 $LOOP
sudo mkdir -p ${LOOPBACK_PATH}
sudo mount -t ext2 $LOOP ${LOOPBACK_PATH}
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
