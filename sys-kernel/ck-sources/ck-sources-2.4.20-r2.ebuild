# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ck-sources/ck-sources-2.4.20-r2.ebuild,v 1.3 2003/02/13 16:36:02 vapier Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  

ETYPE="sources"

inherit kernel || die

OKV="2.4.20"
KV="2.4.20-ck${PR/r/}"
S=${WORKDIR}/linux-${KV}

EXTRAVERSION="-ck${PR/r/}"
DESCRIPTION="Full sources for the Stock Linux kernel Con Kolivas's high performance patchset"
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2 http://members.optusnet.com.au/ckolivas/kernel/ck${PR/r/}_${OKV}.patch.bz2"

KEYWORDS="x86 -ppc"
SLOT="${KV}"

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	bzcat ${DISTDIR}/ck${PR/r/}_${OKV}.patch.bz2 | patch -p0 || die "-patch failed"

	mv linux-${OKV} linux-${KV} || die

	cd linux-${KV}

	kernel_universal_unpack
}


