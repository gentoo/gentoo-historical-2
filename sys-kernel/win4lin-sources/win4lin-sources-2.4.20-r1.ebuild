# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/win4lin-sources/win4lin-sources-2.4.20-r1.ebuild,v 1.4 2003/02/13 16:46:35 vapier Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  They can be the same.

ETYPE="sources"

inherit kernel || die

OKV="2.4.20"

#add one of these in if this is for a pre or rc kernel
#KERN_PATCH="patch-2.4.20-rc1.bz2"

DESCRIPTION="Full sources for the linux kernel with win4lin support"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	 https://www.netraverse.com/member/downloads/files/mki-adapter.patch
	 https://www.netraverse.com/member/downloads/files/Kernel-Win4Lin3-${OKV}.patch"

KEYWORDS="x86"
SLOT="${KV}"

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	mv linux-${OKV} linux-${KV} || die

	cd linux-${KV}

	cat ${DISTDIR}/mki-adapter.patch|patch -p1 || die "-mki-adapter patch failed"
	cat ${DISTDIR}/Kernel-Win4Lin3-${OKV}.patch|patch -p1 || die "-Win4Lin3 patch failed"

	kernel_universal_unpack
}
