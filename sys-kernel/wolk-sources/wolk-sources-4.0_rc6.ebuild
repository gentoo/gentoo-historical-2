# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/wolk-sources/wolk-sources-4.0_rc6.ebuild,v 1.2 2003/04/27 15:47:19 livewire Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  They can be the same.

ETYPE="sources"

inherit kernel || die

OKV=2.4.20
EXTRAVERSION=-wolk4.0s-rc6
KV=${OKV}${EXTRAVERSION}
S=${WORKDIR}/linux-${KV}
DESCRIPTION="Working Overloaded Linux Kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://sourceforge/wolk/linux-2.4.20-wolk4.0s-rc4.patch.bz2
		mirror://sourceforge/wolk/linux-2.4.20-wolk4.0s-rc4-to-rc5.patch.bz2
		mirror://sourceforge/wolk/linux-2.4.20-wolk4.0s-rc5-to-pre-final.patch.bz2"
KEYWORDS="~x86"
SLOT="${KV}"
HOMEPAGE="http://wolk.sourceforge.net http://www.kernel.org"

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	mv linux-${OKV} linux-${KV} || die
	cd ${WORKDIR}/linux-${KV}
	bzcat ${DISTDIR}/linux-2.4.20-wolk4.0s-rc4.patch.bz2 | patch -p1 || die
	bzcat ${DISTDIR}/linux-2.4.20-wolk4.0s-rc4-to-rc5.patch.bz2 | patch -p1 || die
	bzcat ${DISTDIR}/linux-2.4.20-wolk4.0s-rc5-to-pre-final.patch.bz2 |patch -p1 || die
	cd ${S}
	mv Makefile Makefile.orig
	sed -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" \
	Makefile.orig >Makefile || die # test, remove me if Makefile ok
        rm Makefile.orig

	echo "KV=${KV}" >/tmp/KV
}
src_install() {
	dodir /usr/src
	echo ">>> Copying sources..."
	dodoc ${FILESDIR}/patches.txt
	mv ${WORKDIR}/linux* ${D}/usr/src
}

pkg_postinst() {
	einfo
	einfo   "If you use NVIDIA modules, you will need to use the supplied"
	einfo   "rmap patch in /usr/src/linux-2.4.20-wolk4.0s-pre10/userspace-patches"
	einfo   "against your nvidia kernel driver source"
	einfo   "cd NVIDIA_kernel-1.0-XXXX " 
	einfo	"patch -p1 </usr/src/linux-2.4.20-wolk4.0s-pre10/userspace-patches/"
	einfo   "NVIDIA_kernel-1.0-4191-2.4-rmap15b.patch"                
	einfo   "This patch works fine with NVIDIA_kernel-1.0-3123 also"
	einfo   ""
	einfo   "Patches not needed for Nvidia drivers 4363+"
}

