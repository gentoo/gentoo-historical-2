# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/development-sources/development-sources-2.5.44.ebuild,v 1.1 2002/10/19 07:54:46 lostlogic Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

#we use this next variable to avoid duplicating stuff on cvs
GFILESDIR=${PORTDIR}/sys-kernel/linux-sources/files
OKV=${PV}
KV=${PV}
S=${WORKDIR}/linux-${KV}
ETYPE="sources"

# What's in this kernel?

# INCLUDED:
# beta 2.5.36 kernel sources

DESCRIPTION="Full sources for the Gentoo Linux kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.5/linux-${OKV}.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org/" 
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

if [ $ETYPE = "sources" ] && [ -z "`use build`" ]
then
	#console-tools is needed to solve the loadkeys fiasco; binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
	DEPEND=">=sys-devel/binutils-2.11.90.0.31"
	RDEPEND=">=sys-libs/ncurses-5.2 sys-devel/perl >=sys-apps/modutils-2.4.2 sys-devel/make"
fi

[ -z "$LINUX_HOSTCFLAGS" ] && LINUX_HOSTCFLAGS="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -I${S}/include"

src_unpack() {
	cd ${WORKDIR}
	unpack linux-${OKV}.tar.bz2
#	mv linux linux-${KV} || die
	cd ${S}
	
	#sometimes we have icky kernel symbols; this seems to get rid of them
	make mrproper || die

	#this file is required for other things to build properly, so we autogenerate it
#	make include/linux/version.h || die

	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R 0.0 *
	chmod -R a+r-w+X,u+w *

	# Gentoo Linux uses /boot, so fix 'make install' to work properly
#	cd ${S}
#	mv Makefile Makefile.orig
#	sed -e 's:#export\tINSTALL_PATH:export\tINSTALL_PATH:' \
#		Makefile.orig >Makefile || die # test, remove me if Makefile ok
#	rm Makefile.orig
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
		echo ">>> Copying sources..."
		mv ${WORKDIR}/* ${D}/usr/src
	else
		#linux-headers
		dodir /usr/include/linux
		cp -ax ${S}/include/linux/* ${D}/usr/include/linux
		rm -rf ${D}/usr/include/linux/modules
		dodir /usr/include/asm
		cp -ax ${S}/include/asm-i386/* ${D}/usr/include/asm
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
	if [ ! -e ${ROOT}usr/src/linux-beta ]
	then

		ln -sf linux-${KV} ${ROOT}/usr/src/linux-beta
	fi
}


