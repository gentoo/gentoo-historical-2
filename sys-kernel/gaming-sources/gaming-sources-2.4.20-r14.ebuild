# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gaming-sources/gaming-sources-2.4.20-r14.ebuild,v 1.1 2004/06/24 12:51:11 plasmaroo Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  

ETYPE="sources"
inherit kernel eutils

OKV="2.4.20"
EXTRAVERSION="-gaming-${PR}"
KV="${OKV}${EXTRAVERSION}"
S=${WORKDIR}/linux-${KV}
CKV="2.4.20-ck7"

DESCRIPTION="Full sources for the Gentoo gaming-optimized kernel"
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2 mirror://gentoo/patches-${KV/14/5}.tar.bz2 http://www.plumlocosoft.com/kernel/patches/2.4/${OKV}/linux-${CKV}.patch.bz2"

KEYWORDS="x86 -ppc"
SLOT="${KV}"

src_unpack() {
	unpack linux-${OKV}.tar.bz2 patches-${KV/14/5}.tar.bz2
	bzcat ${DISTDIR}/linux-${CKV}.patch.bz2 | patch -p0 || die "-ck patch failed"

	mv linux-${OKV} linux-${KV} || die

	cd ${KV/14/5} || die
	rm 98_nforce2_agp.patch # In -ck7
	kernel_src_unpack

	epatch ${FILESDIR}/${P}.CAN-2003-0985.patch || die "Failed to patch mremap() vulnerability!"
	epatch ${FILESDIR}/${P}.CAN-2004-0001.patch || die "Failed to apply AMD64 ptrace patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0010.patch || die "Failed to add the CAN-2004-0010 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0109.patch || die "Failed to add the CAN-2004-0109 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0133.patch || die "Failed to add the CAN-2004-0075 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0177.patch || die "Failed to add the CAN-2004-0177 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0178.patch || die "Failed to add the CAN-2004-0178 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0181.patch || die "Failed to add the CAN-2004-0075 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0394.patch || die "Failed to add the CAN-2004-0075 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0427.patch || die "Failed to add the CAN-2004-0075 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0495.patch || die "Failed to add the CAN-2004-0495 patch!"
	epatch ${FILESDIR}/${P}.CAN-2004-0535.patch || die "Failed to add the CAN-2004-0535 patch!"

	epatch ${FILESDIR}/do_brk_fix.patch || die "Failed to patch do_brk() vulnerability!"
	epatch ${FILESDIR}/${P}.I2C_Limits.patch || die "Failed to patch the I2C i2cdev_ioctl() kmalloc() bug!"
	epatch ${FILESDIR}/${P}.rtc_fix.patch || die "Failed to patch RTC vulnerabilities!"
	epatch ${FILESDIR}/${P}.munmap.patch || die "Failed to apply munmap patch!"
	epatch ${FILESDIR}/${P}.FPULockup-53804.patch || die "Failed to apply FPU-lockup patch!"
}
