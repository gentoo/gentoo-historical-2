# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/usermode-sources/usermode-sources-2.4.19-r43.ebuild,v 1.1 2003/01/27 16:20:09 tantive Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

#we use this next variable to avoid duplicating stuff on cvs
GFILESDIR=${PORTDIR}/sys-kernel/linux-sources/files
OKV=${PV}
KV=${PVR}
UML_PATCH="uml-patch-${PV}-`echo ${PR}|sed -e 's:r\([0-9]\+\):\1:'`"
S=${WORKDIR}/linux-${KV}

# What's in this kernel?

# INCLUDED:
#	User mode linux patch
#	http://user-mode-linux.sourceforge.net
#	UML clashes with the current Gentoo patch, so I've ignored it for now.

DESCRIPTION="Full (vanilla) sources for the User Mode Linux kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2  http://prdownloads.sourceforge.net/user-mode-linux/${UML_PATCH}.bz2"
HOMEPAGE="http://www.kernel.org/ http://user-mode-linux.sourceforge.net" 
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="~x86 -ppc -sparc  -alpha"

#console-tools is needed to solve the loadkeys fiasco.
#binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
DEPEND=">=sys-devel/binutils-2.11.90.0.31 sys-devel/perl"
RDEPEND=">=sys-libs/ncurses-5.2"

[ -z "$LINUX_HOSTCFLAGS" ] && LINUX_HOSTCFLAGS="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -I${S}/include"

src_unpack() {

	cd ${WORKDIR}
	unpack linux-${OKV}.tar.bz2
	mv linux-${OKV} linux-${KV} || die
	cd ${S}
	bzcat ${DISTDIR}/${UML_PATCH}.bz2 | patch -d ${S} -p1
	echo "Preparing for compilation..."
	
	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R 0.0 *
	chmod -R a+r-w+X,u+w *

}
		
src_compile() {
	echo "Nothing to compile.  That's up to the user"
}

src_install() {
		dodir /usr/src/uml
		cd ${S}
		echo ">>> Copying sources..."
		mv ${WORKDIR}/* ${D}/usr/src/uml
		cd ${D}/usr/src/uml
		ln -sf linux-${KV} linux
}


