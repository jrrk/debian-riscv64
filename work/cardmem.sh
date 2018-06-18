echo ' # partition table of image\' \
     'unit: sectors\' \
     '\' \
     '   image1 : start=     2048, size=  8382464, Id=83, bootable\' \
     '   image2 : start=        0, size=        0, Id= 0\' \
     '   image3 : start=        0, size=        0, Id= 0\' \
     '   image4 : start=        0, size=        0, Id= 0\' \
    | tr '\\' '\012' | sed 's=^\ ==' | tee $@.log | /sbin/sfdisk -f cardmem.bin
