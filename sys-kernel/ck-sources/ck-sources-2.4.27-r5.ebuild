# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ck-sources/ck-sources-2.4.27-r5.ebuild,v 1.1 2004/12/24 16:08:23 plasmaroo Exp $

ETYPE="sources"

inherit kernel-2
detect_version

# CKV=con kolivas release version
CKV="1"

KEYWORDS="~x86 -ppc"
IUSE=""
UNIPATCH_STRICTORDER="Y"
UNIPATCH_LIST="${DISTDIR}/patch-${PV}-lck${CKV}.bz2
	${DISTDIR}/${P}-CAN-2004-0814.patch
	${FILESDIR}/${P}.CAN-2004-0394.patch
	${FILESDIR}/${P}.cmdlineLeak.patch
	${FILESDIR}/${P}.XDRWrapFix.patch
	${FILESDIR}/${P}.binfmt_elf.patch
	${FILESDIR}/${P}.smbfs.patch
	${FILESDIR}/${PN}.AF_UNIX.patch
	${FILESDIR}/${P}.vma.patch
	${FILESDIR}/${P}.binfmt_a.out.patch
	${FILESDIR}/${P}.CAN-2004-1016.patch
	${FILESDIR}/${P}.CAN-2004-1056.patch
	${FILESDIR}/${P}.CAN-2004-1137.patch"

# Something is weird with kernel-2.eclass; sticking in vma at the start gets it applied after a.out (which is what we need)...
# Sticking it after doesn't...

DESCRIPTION="Full sources for the Stock Linux kernel Con Kolivas's high performance patchset"
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"
SRC_URI="${KERNEL_URI}
	http://www.plumlocosoft.com/kernel/patches/2.4/${PV}/${PV}-lck${CKV}/patch-${PV}-lck${CKV}.bz2
	http://dev.gentoo.org/~plasmaroo/patches/kernel/misc/security/${P}-CAN-2004-0814.patch"
