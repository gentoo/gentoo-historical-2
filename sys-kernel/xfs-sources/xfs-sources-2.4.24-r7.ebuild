# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xfs-sources/xfs-sources-2.4.24-r7.ebuild,v 1.1 2004/06/14 22:02:20 plasmaroo Exp $

ETYPE="sources"

inherit kernel eutils
IUSE=""
OKV="`echo ${PV}|sed -e 's:^\([0-9]\+\.[0-9]\+\.[0-9]\+\).*:\1:'`"
EXTRAVERSION="-${PN/-*/}-${PR}"
KV=${OKV}${EXTRAVERSION}

S=${WORKDIR}/linux-${KV}

# Documentation on the patches contained in this kernel will be installed
# to /usr/share/doc/xfs-sources-${PV}/patches.txt.gz

DESCRIPTION="Full sources for the XFS Specialized Gentoo Linux kernel"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	http://dev.gentoo.org/~scox/kernels/v2.4/xfs-sources-${PV}-r3.patch.bz2"

KEYWORDS="x86 -ppc -sparc"
SLOT="${KV}"

src_unpack() {
	unpack ${A}
	mv linux-${OKV} linux-${KV} || die

	cd linux-${KV}

	bzcat ${DISTDIR}/xfs-sources-${PV}-r3.patch.bz2 | patch -p1 \
		|| die "Failed to patch kernel"

	cd ${S}
	epatch ${FILESDIR}/${P}.munmap.patch || die "Failed to apply munmap!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0010.patch || die "Failed to add the CAN-2004-0010 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0075.patch || die "Failed to add the CAN-2004-0075 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0109.patch || die "Failed to add the CAN-2004-0109 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0133.patch || die "Failed to add the CAN-2004-0133 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0177.patch || die "Failed to add the CAN-2004-0177 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0178.patch || die "Failed to add the CAN-2004-0178 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0181.patch || die "Failed to add the CAN-2004-0181 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0394.patch || die "Failed to add the CAN-2004-0394 patch!"
	epatch ${FILESDIR}/${PN}.CAN-2004-0427.patch || die "Failed to add the CAN-2004-0427 patch!"
	epatch ${FILESDIR}/${PN}.FPULockup-53804.patch || die "Failed to apply FPU-lockup patch!"

	make mrproper || die "make mrproper failed"
	kernel_universal_unpack
}
