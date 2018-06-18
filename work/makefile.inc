export CHROOT_PATH=work/debian-riscv64-chroot

cardmem.bin:
	mkdir -p work
	dd if=/dev/zero of=work/cardmem.bin bs=2M count=2047
	sh cardmem.sh

chroot: $(CHROOT_PATH)/multistrap-riscv64.conf

${CHROOT_PATH}/multistrap-riscv64.conf: work/multistrap-riscv64.conf
	mkdir -p work
	sudo multistrap --no-auth -d ${CHROOT_PATH} -f $<
	sudo cp -p $< ${CHROOT_PATH}

clean:
	rm -rf bin etc dev home lib proc sbin sys tmp usr mnt nfs root run init

init: chroot
	make clean
	mkdir -p bin etc dev home lib proc sbin sys tmp usr mnt nfs root run usr/bin usr/lib usr/sbin usr/share/perl5 lib/riscv64-linux-gnu usr/lib/riscv64-linux-gnu # usr/share/sysvinit
	sudo mknod dev/null c 1 3
	sudo mknod dev/tty c 5 0
	sudo mknod dev/zero c 1 5
	sudo mknod dev/console c 5 1
	sudo mknod dev/random c 1 8
	sudo mknod dev/urandom c 1 9
	sudo mknod dev/mmcblk0 b 179 0
	sudo mknod dev/mmcblk0p1 b 179 1
	sudo mknod dev/mmcblk0p2 b 179 2
	cp -p ${CHROOT_PATH}/bin/bash-static ./bin
	cp -p ${CHROOT_PATH}/sbin/ifconfig ./sbin
	cp -p ${CHROOT_PATH}/sbin/switch_root ./sbin
	cp -p ${CHROOT_PATH}/bin/ping ./bin
	cp -p ${CHROOT_PATH}/bin/more ./bin
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
	cp -p ${CHROOT_PATH}/lib/riscv64-linux-gnu/libtinfo.so.5 ./lib/riscv64-linux-gnu
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
	cp work/init.sh init
	chmod +x init
	#mv init{,rc}
	#ln -s /bin/bash init

cpio: ../riscv-linux/initramfs.cpio

../riscv-linux/initramfs.cpio: init
	echo "find . -path ./work -prune -o -path ./.git -prune -o -print | cpio -H newc -o > $@" | fakeroot

work:
	WORK=/local/scratch-legacy/debian
	sudo rm -rf $WORK
	sudo mkdir -p $WORK
	(cd ${CHROOT_PATH}; sudo tar cf - .)|(cd $WORK; sudo tar xf -)
	sudo umount ${CHROOT_PATH}
	sudo losetup -d $LOOP
