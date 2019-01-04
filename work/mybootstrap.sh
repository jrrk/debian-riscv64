#First get rid of the previous chroot
sudo rm -rf work/debian-riscv64-chroot
#Make a directory to hold the riscv emulator
sudo mkdir -p work/debian-riscv64-chroot/usr/bin
#Copy the emulator
sudo cp ../qemu/riscv64-linux-user/qemu-riscv64 work/debian-riscv64-chroot/usr/bin/qemu-riscv64-static
#Make sure the correct keyring is installed
sudo apt install debootstrap debian-ports-archive-keyring
#Perform the first stage bootstrap
sudo debootstrap --arch=riscv64 --variant=minbase --keyring=/etc/apt/trusted.gpg \
     --include=gnupg sid work/debian-riscv64-chroot \
     http://deb.debian.org/debian-ports || exit 1
#Create the tmp directory (if needed)
sudo mkdir -p -m 777 work/debian-riscv64-chroot/tmp
#Update sources.list
sudo cp work/sources.list work/debian-riscv64-chroot/etc/apt
#Install the signing key
sudo chroot work/debian-riscv64-chroot apt-key adv --recv-keys --keyserver keyserver.ubuntu.com DA1B2CEA81DCBC61
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
#Setup locales
sudo chroot work/debian-riscv64-chroot dpkg-reconfigure locales
#Setup timezone
sudo chroot work/debian-riscv64-chroot dpkg-reconfigure tzdata
#Remove the dummy start-stop-daemon
#sudo chroot work/debian-riscv64-chroot mv /sbin/start-stop-daemon{.REAL,}
