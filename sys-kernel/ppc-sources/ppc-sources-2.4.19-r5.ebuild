# Copyright 1999-2002 Gentoo Technologies, Inc. 
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Kain X <kain@gentoo.org>
# $Id: ppc-sources-2.4.19-r5.ebuild,v 1.1 2002/05/27 02:26:44 kain Exp $ 

#OKV=original kernel version, KV=patched kernel version.  They can be the same.

#we use this next variable to avoid duplicating stuff on cvs
GFILESDIR=${PORTDIR}/sys-kernel/linux-sources/files
OKV=2.4.18
KV=${PVR}
S=${WORKDIR}/linux-${KV}
ETYPE="sources"

# What's in this kernel?

# INCLUDED:
#	2.4.19-pre8-ben0
#	ati.2 Xfree86 4.2.0 DRM
#	Selected pre8aa patches:
#	00_lowlatency-fixes-5
#	70_xfs-1.1-0
#	71_xfs-kiobuf-slab-1
#	72_xfs-O_DIRECT-1
#	73_xfs-blksize-PAGE_SIZE-1
#	Ani Joshi's rivafb bigendian fixes from YDL: I think these are in benh now


DESCRIPTION="Full sources for the Gentoo Linux PPC kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2 http://ftp.sunsite.dk/projects/gentooppc/distfiles/linux-gentoo-ppc-${KV}.patch.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org/" 
LICENSE="GPL-2"

if [ $ETYPE = "sources" ] && [ -z "`use build`" ]
then
	#console-tools is needed to solve the loadkeys fiasco; binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
	DEPEND=">=sys-devel/binutils-2.11.90.0.31"
	RDEPEND=">=sys-libs/ncurses-5.2 sys-devel/perl >=sys-apps/modutils-2.4.2 sys-devel/make"
fi

GENTOOPATCH=${DISTDIR}/linux-gentoo-ppc-${KV}.patch.bz2

[ -z "$LINUX_HOSTCFLAGS" ] && LINUX_HOSTCFLAGS="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -I${S}/include"

src_unpack() {
	cd ${WORKDIR}
	unpack linux-${OKV}.tar.bz2
	mv linux linux-${KV} || die
	cd ${S}
	pwd
	bzcat ${GENTOOPATCH} | patch -p1 || die # Patch the kernel
	
	#sometimes we have icky kernel symbols; this seems to get rid of them
	make mrproper || die

	#this file is required for other things to build properly, so we autogenerate it
	make include/linux/version.h || die

	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R 0.0 *
	chmod -R a+r-w+X,u+w *

	# Gentoo Linux uses /boot, so fix 'make install' to work properly
	cd ${S}
	mv Makefile Makefile.orig
	sed -e 's:#export\tINSTALL_PATH:export\tINSTALL_PATH:' \
		Makefile.orig >Makefile || die # test, remove me if Makefile ok
	rm Makefile.orig
}

src_compile() {
	if [ "$ETYPE" = "headers" ]
	then
		yes "" | make oldconfig		
		echo "Ignore any errors from the yes command above."
	fi
}

src_install() {
	if [ "$ETYPE" = "sources" ]
	then
		dodir /usr/src
		cd ${S}
		echo ">>> Copying sources..."
		mv ${WORKDIR}/* ${D}/usr/src
	else
		#linux-headers
		yes "" | make oldconfig
		echo "Ignore any errors from the yes command above."
		make dep
		dodir /usr/include/linux
		cp -ax ${S}/include/linux/* ${D}/usr/include/linux
		dodir /usr/include/asm
		cp -ax ${S}/include/asm-ppc/* ${D}/usr/include/asm
	fi
}

pkg_preinst() {
	if [ "$ETYPE" = "headers" ] 
	then
		[ -L ${ROOT}usr/include/linux ] && rm ${ROOT}usr/include/linux
		[ -L ${ROOT}usr/include/asm ] && rm ${ROOT}usr/include/asm
		true
	fi
}

pkg_postinst() {
	[ "$ETYPE" = "headers" ] && return
	if [ ! -e ${ROOT}usr/src/linux ]
	then
		rm -f ${ROOT}usr/src/linux
		ln -sf linux-${KV} ${ROOT}/usr/src/linux
	fi
}
