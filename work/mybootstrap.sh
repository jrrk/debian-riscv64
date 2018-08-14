sudo rm -rf work/debian-riscv64-chroot
sudo mkdir -p work/debian-riscv64-chroot/usr/bin
sudo cp $TOP/qemu/riscv64-linux-user/qemu-riscv64 work/debian-riscv64-chroot/usr/bin/qemu-riscv64-static
sudo debootstrap --foreign --arch=riscv64 --variant=minbase --keyring=/etc/apt/trusted.gpg \
     --include=adduser,libc6,gnupg sid work/debian-riscv64-chroot \
     http://ftp.ports.debian.org/debian-ports || exit 1
sudo chroot work/debian-riscv64-chroot /debootstrap/debootstrap --second-stage
sudo mkdir -m 777 work/debian-riscv64-chroot/tmp
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
sudo chroot work/debian-riscv64-chroot apt install -y \
        debian-ports-archive-keyring nfs-common busybox \
        libncursesw5 libtinfo5 \
        nvi wget net-tools ifupdown sysvinit-core iputils-ping isc-dhcp-client locales ntp lynx whiptail dialog \
        ca-certificates lsof tcpdump iputils-arping openssh-client openssh-server bash-static \
        nfs-common rdate dropbear-bin iperf3 dosfstools wamerican file libmagic1 libmagic-mgc \
        menu xterm sudo xbitmaps libfontconfig1 libfreetype6 libice6 libutempter0 \
        fontconfig-config libpng16-16 x11-common \
        libsm6 fonts-liberation ethtool net-tools tcpdump \
        iperf3 gcc-8 ocaml-nox build-essential netcat-openbsd

