export CHROOT_PATH=work/debian-riscv64-chroot

chroot: ../rootfs.tar.xz

../rootfs.tar.xz: $(CHROOT_PATH)/mybootstrap.sh
	sudo tar cJf - -C ${CHROOT_PATH} . > $@

${CHROOT_PATH}/mybootstrap.sh: work/mybootstrap.sh
	mkdir -p work
	sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 06AED62430CB581C 8B48AD6246925553 7638D0442B90D010 04EE7237B7D453EC
	sh work/mybootstrap.sh
	sudo cp -p $< ${CHROOT_PATH}

clean:
	rm -rf bin etc dev home lib proc sbin sys tmp usr mnt nfs root run init

initnfs: chroot
	make clean
	mkdir -p bin etc dev home lib proc sbin sys tmp usr mnt nfs root run usr/bin usr/lib usr/sbin usr/share/perl5 usr/share/udhcpc lib/riscv64-linux-gnu usr/lib/riscv64-linux-gnu # usr/share/sysvinit
	cp -p work/usr-share-udhcpc-default.script usr/share/udhcpc/default.script
	cp -p ${CHROOT_PATH}/sbin/mount.nfs ./sbin
	cp -p ${CHROOT_PATH}/sbin/switch_root ./sbin
	cp -p ${CHROOT_PATH}/bin/busybox ./bin
	cp -p ${CHROOT_PATH}/lib/ld-linux-riscv64-lp64d.so.1 ./lib
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libblkid.so.1 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libcom_err.so.2 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libc.so.6 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libdl.so.2 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libgssapi_krb5.so.2 ./usr/lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libk5crypto.so.3 ./usr/lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libkeyutils.so.1 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libkrb5.so.3 ./usr/lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/usr/lib/riscv64-linux-gnu/libkrb5support.so.0 ./usr/lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libmount.so.1 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libnsl.so.1 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libpcre.so.3 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libpthread.so.0 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libresolv.so.2 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/librt.so.1 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libselinux.so.1 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libtirpc.so.1 ./lib/riscv64-linux-gnu
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libuuid.so.1 ./lib/riscv64-linux-gnu
	cp work/busyboxnfs.sh init
	chmod +x init

initmmc: chroot
	make clean
	mkdir -p bin etc dev home lib proc sbin sys tmp usr mnt nfs root run usr/bin usr/lib usr/sbin usr/share/perl5 lib/riscv64-linux-gnu usr/lib/riscv64-linux-gnu # usr/share/sysvinit
	cp -p ${CHROOT_PATH}/sbin/switch_root ./sbin
	cp -p ${CHROOT_PATH}/bin/busybox ./bin
	cp -p ${CHROOT_PATH}/lib/ld-linux-riscv64-lp64d.so.1 ./lib
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libc.so.6 ./lib/riscv64-linux-gnu
	cp work/busyboxmmc.sh init
	chmod +x init

cpio: ../riscv-linux/initramfsnfs.cpio ../riscv-linux/initramfsmmc.cpio

../riscv-linux/initramfsnfs.cpio: initnfs
	echo "mknod dev/null c 1 3; mknod dev/tty c 5 0; mknod dev/zero c 1 5; mknod dev/console c 5 1; mknod dev/random c 1 8; mknod dev/urandom c 1 9; mknod dev/mmcblk0 b 179 0; mknod dev/mmcblk0p1 b 179 1; mknod dev/mmcblk0p2 b 179 2; find . -path ./work -prune -o -path ./.git -prune -o -print | cpio -H newc -o > $@" | fakeroot

../riscv-linux/initramfsmmc.cpio: initmmc
	echo "mknod dev/null c 1 3; mknod dev/tty c 5 0; mknod dev/zero c 1 5; mknod dev/console c 5 1; mknod dev/random c 1 8; mknod dev/urandom c 1 9; mknod dev/mmcblk0 b 179 0; mknod dev/mmcblk0p1 b 179 1; mknod dev/mmcblk0p2 b 179 2; find . -path ./work -prune -o -path ./.git -prune -o -print | cpio -H newc -o > $@" | fakeroot

deps:
	@find . -path ./work -prune -o -path ./.git -prune -o -print|xargs file|grep RISC-V|cut -d: -f1|xargs riscv64-unknown-elf-readelf -d |grep NEEDED|cut -d: -f2|sort -u
