# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-2.4.25-r15.ebuild,v 1.1 2005/01/08 21:29:55 plasmaroo Exp $

ETYPE="sources"
inherit kernel-2
detect_version

KEYWORDS="x86 -ppc"
IUSE=''

UNIPATCH_STRICTORDER='Y'
UNIPATCH_LIST="
	${DISTDIR}/${P}.patch.bz2
	${FILESDIR}/${PN}-2.4.CAN-2004-0109.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0133.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0177.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0178.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0181.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0394.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0427.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0495.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0497.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0535.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-0685.patch
	${FILESDIR}/${PN}-2.4.FPULockup-53804.patch
	${FILESDIR}/${PN}-2.4.cmdlineLeak.patch
	${FILESDIR}/${PN}-2.4.XDRWrapFix.patch
	${FILESDIR}/${PN}-2.4.binfmt_elf.patch
	${FILESDIR}/${PN}-2.4.smbfs.patch
	${DISTDIR}/linux-2.4.26-CAN-2004-0415.patch
	${DISTDIR}/${P}-CAN-2004-0814.patch
	${FILESDIR}/${PN}-2.4.AF_UNIX.patch
	${FILESDIR}/${PN}-2.4.binfmt_a.out.patch
	${FILESDIR}/${PN}-2.4.vma.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-1016.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-1056.patch
	${FILESDIR}/${PN}-2.4.CAN-2004-1137.patch
	${FILESDIR}/${PN}-2.4.77094.patch
	${FILESDIR}/${PN}-2.4.brk-locked.patch"

DESCRIPTION="Full sources including the gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} http://dev.gentoo.org/~livewire/${P}.patch.bz2
	 http://dev.gentoo.org/~plasmaroo/patches/kernel/misc/security/linux-2.4.26-CAN-2004-0415.patch
	 http://dev.gentoo.org/~plasmaroo/patches/kernel/misc/security/${P}-CAN-2004-0814.patch"

