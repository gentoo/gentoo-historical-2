# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-sources/linux-sources-2.4.0.11-r3.ebuild,v 1.1 2001/01/27 02:00:56 drobbins Exp $

S=${WORKDIR}/linux
KV=2.4.0-ac11
LVMV=0.9.1_beta3
if [ "$PN" = "linux" ]
then
	DESCRIPTION="Linux kernel, including modules, binary tools, libraries and includes"
else
	DESCRIPTION="Kernel source package, including full sources, binary tools and libraries"
fi
SRC_URI="
http://www.kernel.org/pub/linux/kernel/v2.4/linux-2.4.0.tar.bz2
http://www.kernel.org/pub/linux/kernel/people/alan/2.4/patch-${KV}.bz2
http://www.netroedge.com/~lm78/archive/lm_sensors-2.5.5.tar.gz 
http://oss.software.ibm.com/developerworks/opensource/jfs/project/pub/jfs-0.1.4-patch.tar.gz
ftp://ftp.alsa-project.org/pub/driver/alsa-driver-0.5.10a.tar.bz2
ftp://ftp.sistina.com/pub/LVM/0.9.1_beta/lvm_${LVMV}.tar.gz
http://www.braque.dhs.org/pub/linux/kernel/patch/patch-_against_2.4.1-pre10_-knfsdops-reiserfs.gz"

HOMEPAGE="http://www.kernel.org/
	  http://www.netroedge.com/~lm78/
	  http://www.namesys.com
	  http://www.sistina.com/lvm/
	  http://www.alsa-project.org"

src_unpack() {

	#unpack kernel and apply reiserfs-related patches
	cd ${WORKDIR}
    unpack linux-2.4.0.tar.bz2
    cd ${S}
    echo "Applying ${KV} patch..."
    try bzip2 -dc ${DISTDIR}/patch-${KV}.bz2 | patch -p1
    echo "Applying reiserfs-nfsd patch..."
    try gzip -dc ${DISTDIR}/patch-_against_2.4.1-pre10_-knfsdops-reiserfs.gz | patch -p1
    echo "Applying reiserfs-superfs.c fix..."
    cd fs/reiserfs
    try patch -p0 < ${FILESDIR}/${PV}-r${PR}/super.diff
    mkdir ${S}/extras

	#create and apply LVM patch.  The tools get built later.
	cd ${S}/extras
    echo "Unpacking and applying LVM patch..."
    unpack lvm_${LVMV}.tar.gz
	cd LVM/${LVMV}
    try ./configure --prefix=/ --mandir=/usr/man
	cd PATCHES
	try make
	cd ${S}
	#the -l option allows this patch to apply cleanly (ignore whitespace changes)
	try patch -l -p1 < ${S}/extras/LVM/${LVMV}/PATCHES/lvm-${LVMV}-${KV}.patch

	#unpack alsa drivers
	echo "Unpacking ALSA drivers..."
    cd ${S}/extras
    unpack alsa-driver-0.5.10a.tar.bz2

	#unpack and apply the lm_sensors patch
    echo "Unpacking and applying lm_sensors patch..."
    cd ${S}/extras
    unpack lm_sensors-2.5.5.tar.gz
    cd lm_sensors-2.5.5
    mkpatch/mkpatch.pl . ${S} > ${S}/lm_sensors-patch
    rmdir src
    ln -s ../.. src
    cp Makefile Makefile.orig
    sed -e "s:^LINUX=.*:LINUX=src:" \
        -e "s/^COMPILE_KERNEL.*/COMPILE_CERNEL := 0/" \
        -e "s:^I2C_HEADERS.*:I2C_HEADERS=src/include:" \
        -e "s#^DESTDIR.*#DESTDIR := ${D}#" \
        -e "s#^PREFIX.*#PREFIX := /usr#" \
        -e "s#^MANDIR.*#MANDIR := /usr/share/man#" \
        Makefile.orig > Makefile
    cd ${S}
    patch -p1 < lm_sensors-patch

	#get sources ready for compilation or for sitting at /usr/src/linux
    echo "Preparing for compilation..."
    cd ${S}
    #sometimes we have icky kernel symbols; this seems to get rid of them
    make mrproper
    #this is the configuration for the default kernel
    try cp ${FILESDIR}/${PV}-r${PR}/config .config
    try cp ${FILESDIR}/${PV}-r${PR}/autoconf.h include/linux/autoconf.h
    try make include/linux/version.h

    #fix silly permissions in tarball
    cd ${WORKDIR}
    chown -R root.root linux
}

src_compile() {

    #LVM tools are included even in the linux-sources package
    cd ${S}/extras/LVM/${LVMV}
    try make

    cd ${S}
    try make symlinks
    try make dep

    if [ "$PN" != "linux" ]
    then
	return
    fi

    cd ${S}/extras/lm_sensors-2.5.5
    try make

    cd ${S}
    try make bzImage
    try make modules

    cd ${S}/extras/alsa-driver-0.5.10a
    try ./configure --with-kernel=${S} --with-isapnp=yes --with-sequencer=yes --with-oss=yes --with-cards=all
    try make
}

src_install() {


	#clean up object files and original executables to reduce size of linux-sources

	dodir /usr/lib
	cd ${S}/extras/LVM/${LVMV}
	#I changed /usr/share/man back to /usr/man... was that a mistake?
	make install prefix=${D} MAN8DIR=${D}/usr/man/man8 LIBDIR=${D}/lib
	#no need for a static library in /lib
	mv ${D}/lib/liblvm*.a ${D}/usr/lib

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
		# Do we have a bug in modutils ?
		# Meanwhile we use this quick fix (achim)
		dodir /lib/modules/${KV}
		dodir /lib/modules/`uname -r`
		dodir ${D}/lib/modules/${KV}
		try make INSTALL_MOD_PATH=${D} modules_install

		#install ALSA modules
		cd ${S}/extras/alsa-driver-0.5.10a
		dodir /lib/modules/${KV}/misc
		cp modules/*.o ${D}/lib/modules/${KV}/misc
		into /usr
		dosbin snddevices
		dodir /usr/include/linux
		insinto /usr/src/linux-${KV}/include/linux
		cd include
		doins asound.h asoundid.h asequencer.h ainstr_*.h

		#install sensors tools
		cd ${S}/extras/lm_sensors-2.5.5
		make install

		#fix symlink
		cd ${D}/lib/modules/${KV}
		rm build
		ln -sf /usr/src/linux-${KV} build

	else

		cd ${S}
		try make clean
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
		#needs to get fixed for devfs
		fi
    fi
}








