# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux/linux-2.4.0.8.ebuild,v 1.1 2001/01/13 16:29:39 achim Exp $

S=${WORKDIR}/linux
KV=2.4.0-ac8
if [ "$PN" = "linux" ]
then
	DESCRIPTION="Linux kernel, including modules, binary tools, libraries and includes"
else
	DESCRIPTION="Kernel source package, including full sources, binary tools and libraries"
fi
SRC_URI="
http://www.de.kernel.org/pub/linux/kernel/v2.4/linux-2.4.0.tar.bz2
http://www.de.kernel.org/pub/linux/kernel/people/alan/2.4/patch-2.4.0-ac8.bz2
http://www.netroedge.com/~lm78/archive/lm_sensors-2.5.4.tar.gz
http://www.netroedge.com/~lm78/archive/i2c-2.5.4.tar.gz
http://oss.software.ibm.com/developerworks/opensource/jfs/project/pub/jfs-0.1.2-patch.tar.gz
ftp://ftp.alsa-project.org/pub/driver/alsa-driver-0.5.10.tar.bz2
ftp://ftp1.detonator.nvidia.com/pub/drivers/english/XFree86_40/0.9-5/NVIDIA_kernel-0.9-5.tar.gz
ftp://ftp.sistina.com/pub/LVM/0.9/lvm_0.9.tar.gz"

HOMEPAGE="http://www.kernel.org/
	  http://www.netroedge.com/~lm78/
	  http://www.namesys.com
	  http://www.sistina.com/lvm/
	  http://www.alsa-project.org
	  http://www.nvidia.com"



src_unpack() {
    cd ${WORKDIR}
    unpack linux-2.4.0.tar.bz2
    cd ${S}
    echo "Applying ac7 patch..."
    bzip2 -dc ${DISTDIR}/patch-2.4.0-ac8.bz2 | patch -p1

    echo "Applying ReiserFS patch..."
    gzip -dc ${FILESDIR}/${PV}/linux-2.4.0-ac6-reiserfs-3.6.25-maxbytes.diff.gz | patch -p1 

#    echo "Applying ReiserFS fixes patch..."
#    gzip -dc ${FILESDIR}/${PV}/linux-2.4.0-ac3-reiserfs-3.6.25-fixes.patch.gz | patch -p1

#    echo "Applying ReiserFS ac4 fixes..."
#    gzip -dc ${FILESDIR}/${PV}/2.4.0-ac4+reiserfs-max_bytes.patch.gz | patch -p1    

#    echo "Applying reiser-nfs patch..."
#    gzip -dc ${FILESDIR}/${PV}/linux-2.4.0-ac3-reiserfs-3.6.24-nfs.diff.gz | patch -p1

    mkdir extras
    if [ "`use jfs`" ]
    then
	echo "Applying IBM JFS patch..."
	cd extras
	mkdir jfs
	cd jfs
	unpack jfs-0.1.2-patch.tar.gz
	cd ${S}
	patch -p1 < extras/jfs/jfs-common-v0.1.2-patch
	patch -p1 < extras/jfs/jfs-2.4.0-test12-v0.1.1-patch
    fi
	cd ${S}/extras
	echo "Unpacking LVM..."
    	unpack lvm_0.9.tar.gz
	echo "Unpacking ALSA drivers..."
	unpack alsa-driver-0.5.10.tar.bz2
#	echo "Unpacking NVidia drivers..."
#	unpack NVIDIA_kernel-0.9-5.tar.gz
#	cd NVIDIA_kernel-0.9-5
#	# this is a little fix to make the NVidia drivers compile right with test12
#	mv nv.c nv.c.orig
#	echo '#define mem_map_inc_count(p) atomic_inc(&(p->count))' > nv.c
#	echo '#define mem_map_dec_count(p) atomic_dec(&(p->count))' >> nv.c
#	cat nv.c.orig >> nv.c
# This does not work with 2.4.0 daniel can you fix thisOB
	cd ${S}/extras

        #lm_sensors buggy mkpatch.pl in 2.5.4!
	for x in i2c
	do
		echo "Unpacking and applying $x patch..."
		cd ${S}/extras
		unpack ${x}-2.5.4.tar.gz
		cd ${x}-2.5.4
		mkpatch/mkpatch.pl . ${S} > ${S}/${x}-patch
		cd ${S}
		patch -p1 < ${x}-patch
	done

	echo "Preparing for compilation..."
	cd ${S}
	#this is the configuration for the bootdisk/cd
	cp ${FILESDIR}/${PV}/config .config
	cp ${FILESDIR}/${PV}/autoconf.h include/linux/autoconf.h
	try make include/linux/version.h
	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R root.root linux
}

src_compile() {

    cd ${S}
    try make symlinks
    try make dep

    cd ${S}/fs/reiserfs/utils
    try make

#    cd ${S}/lm_sensors-2.5.4
#    try make

    if [ "`use jfs`" ]
    then
	cd ${S}/fs/jfs/utils
	try make
    fi

    if [ "$PN" = "linux" ]
    then
	cd ${S}
	try make bzImage
	try make modules
# 		cd ${S}/extras/NVIDIA_kernel-0.9-5
#		make NVdriver

	cd ${S}/extras/LVM/0.9
	try ./configure --prefix=/
	try make

	cd ${S}/extras/alsa-driver-0.5.10
	try ./configure --with-kernel=${S} --with-isapnp=yes --with-sequencer=yes --with-oss=yes \
		--with-cards=share,dummy,virmidi,interwave,interwave-stb,gusmax,gusextreme,gusclassic,es1688,es18xx,sb8,sb16,sbawe,emu10k1,opl3sa2,mozart,sonicvibes,ens1370,ens1371,ad1816a,ad1848,als100,als4000,azt2320,cs4231,cs4232,cs4236,cs4281,cs461x,cs4281,es968,dt0197h,fm801,es1938,es1968,opti92x-ad1848,opti92x-cs4231,opti93x,serial,trident,sgalaxy,hal2,cmi8330,mtpav,rme96,rme9652,ice1712,intel8x0,via686a,cmipci,ymfpci,maestro3
	# "wavefront" is buggy in 0.5.10
	try make
    fi
}
src_install() {

	cd ${S}/fs/reiserfs/utils
	dodir /usr/man/man8 /sbin
	try make install SBIN=${D}/sbin MANDIR=${D}/usr/man/man8

	cd ${S}/extras/LVM/0.9
	make install prefix=${D} MAN8DIR=${D}/usr/man/man8 LIBDIR=${D}/lib

	if [ "`use jfs`" ]
	then
  	    cd ${S}/fs/jfs/utils
	    cp output/* ${D}/sbin
	    local x
	    for x in `find -iname *.1`
 	    do
		doman $x
	    done
	    for x in `find -iname *.8`
	    do
		doman $x
	    done
	fi

	dodir /usr/src

	if [ "$PN" = "linux" ]
	then

		dodir /usr/src/linux-${KV}
		cd ${D}/usr/src
		ln -sf linux-${KV} linux
		ln -sf linux-${KV} linux-2.4

		#grab includes and documentation only
		dodir /usr/src/linux-${KV}/include/linux
		dodir /usr/src/linux-${KV}/include/asm-i386
		cp -ax ${S}/include ${D}/usr/src/linux-${KV}
		cp -ax ${S}/Documentation ${D}/usr/src/linux-${KV}
		dodir /usr/include
		dosym /usr/src/linux/include/linux /usr/include/linux
		dosym /usr/src/linux/include/asm-i386 /usr/include/asm

		#grab compiled kernel
		dodir /boot/boot
		insinto /boot/boot
		cd ${S}
		doins arch/i386/boot/bzImage

		#grab modules
		dodir /lib/modules/${KV}
		dodir /lib/modules/`uname -r`
		dodir ${D}/lib/modules/${KV}
		try make INSTALL_MOD_PATH=${D} modules_install

		#install ALSA modules
		cd ${S}/extras/alsa-driver-0.5.10
		dodir /lib/modules/${KV}/misc
		cp modules/*.o ${D}/lib/modules/${KV}/misc
		into /usr
		dosbin snddevices
		dodir /usr/include/linux
		insinto /usr/src/linux-${KV}/include/linux
		cd include
		doins asound.h asoundid.h asequencer.h ainstr_*.h

		#install nvidia driver
#		cd ${S}/extras/NVIDIA_kernel-0.9-5
#		insinto /lib/modules/${KV}/video
#		doins NVdriver

		#fix symlink
		cd ${D}/lib/modules/${KV}
		rm build
		ln -sf /usr/src/linux-${KV} build

	else

		#grab all the sources
		cd ${WORKDIR}
		mv linux ${D}/usr/src/linux-${KV}
		cd ${D}/usr/src
		ln -sf linux-${KV} linux

		#remove workdir since our install was dirty and modified ${S}
		#this will cause an unpack to be done next time
		rm -rf ${WORKDIR}
	fi
}

pkg_postinst() {
    if [  "${ROOT}" = "/" ]
    then
	if [ "${PN}" = "linux" ] ; then
	    echo "Creating sounddevices..."
	    /usr/sbin/snddevices
	fi
    fi
}








