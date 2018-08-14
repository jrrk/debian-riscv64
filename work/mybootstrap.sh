sudo rm -rf work/debian-riscv64-chroot
sudo mkdir -p work/debian-riscv64-chroot/usr/bin
sudo cp $TOP/qemu/riscv64-linux-user/qemu-riscv64 work/debian-riscv64-chroot/usr/bin/qemu-riscv64-static
sudo debootstrap --foreign --arch=riscv64 --variant=minbase --keyring=/etc/apt/trusted.gpg \
     --include=adduser,libc6,gnupg,nfs-common,busybox,libsasl2-modules-db sid work/debian-riscv64-chroot \
     http://ftp.ports.debian.org/debian-ports
sudo chroot work/debian-riscv64-chroot /debootstrap/debootstrap --second-stage
cd work/debian-riscv64-chroot/tmp
wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/s/systemd/libudev1_238-2_riscv64.deb
wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/s/systemd/libsystemd0_238-2_riscv64.deb
wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/d/db5.3/libdb5.3_5.3.28-13.1~riscv64_riscv64.deb
wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/libf/libffi/libffi7_3.3~rc0-2~riscv64_riscv64.deb
cd ../../..
sudo chroot work/debian-riscv64-chroot dpkg -i `ls -1 work/debian-riscv64-chroot/tmp | sed 's=^=tmp/='`
sudo cp work/sources.list work/debian-riscv64-chroot/etc/apt
sudo chroot work/debian-riscv64-chroot apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 06AED62430CB581C
sudo chroot work/debian-riscv64-chroot apt update
