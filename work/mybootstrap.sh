#First get rid of the previous chroot
sudo rm -rf work/debian-riscv64-chroot
#Make a directory to hold the riscv emulator
sudo mkdir -p work/debian-riscv64-chroot/usr/bin
#Copy the emulator
sudo cp $TOP/qemu/riscv64-linux-user/qemu-riscv64 work/debian-riscv64-chroot/usr/bin/qemu-riscv64-static
#Perform the first stage bootstrap
sudo debootstrap --foreign --arch=riscv64 --variant=minbase --keyring=/etc/apt/trusted.gpg \
     --include=gnupg sid work/debian-riscv64-chroot \
     http://ftp.ports.debian.org/debian-ports || exit 1
#Perform the second stage using the riscv emulator as an interpreter
#This could fail due to missing dependencies
sudo chroot work/debian-riscv64-chroot /debootstrap/debootstrap --second-stage
#Create the tmp directory (if needed)
sudo mkdir -p -m 777 work/debian-riscv64-chroot/tmp
#Fetch the last few unreleased packages
cd work/debian-riscv64-chroot/tmp
wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/s/systemd/libudev1_238-2_riscv64.deb
wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/s/systemd/libsystemd0_238-2_riscv64.deb
##wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/d/db5.3/libdb5.3_5.3.28-13.1~riscv64_riscv64.deb
wget http://www.debianmirror.de/debian-ports/pool-riscv64/main/libf/libffi/libffi7_3.3~rc0-2~riscv64_riscv64.deb
cd ../../..
#Install the unreleased packages
sudo chroot work/debian-riscv64-chroot dpkg -i `ls -1 work/debian-riscv64-chroot/tmp | sed 's=^=tmp/='`
#Update sources.list
sudo cp work/sources.list work/debian-riscv64-chroot/etc/apt
#Install the signing key
sudo chroot work/debian-riscv64-chroot apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 06AED62430CB581C
#Update the apt fetch paths
sudo chroot work/debian-riscv64-chroot apt update
#Install the development environment
sudo chroot work/debian-riscv64-chroot apt install -y \
        debian-ports-archive-keyring nfs-common busybox libncursesw5 libtinfo5 \
        nvi wget net-tools ifupdown sysvinit-core iputils-ping isc-dhcp-client locales ntp lynx whiptail dialog \
        ca-certificates lsof tcpdump iputils-arping openssh-client openssh-server bash-static \
        rdate iperf3 dosfstools wamerican file libmagic1 libmagic-mgc \
        menu sudo ethtool net-tools tcpdump iperf3 gcc-8 build-essential netcat-openbsd git
#Enable the Ethernet interface
sudo cp work/interfaces work/debian-riscv64-chroot/etc/network
#Update the hostname
sudo cp work/hostname work/debian-riscv64-chroot/etc
#Delete the root password (user will set it later)
sudo chroot work/debian-riscv64-chroot passwd -d root
#Remove the dummy start-stop-daemon
#sudo chroot work/debian-riscv64-chroot mv /sbin/start-stop-daemon{.REAL,}
