# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gaming-sources/gaming-sources-2.4.20-r4.ebuild,v 1.3 2003/09/10 04:33:38 msterret Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  

ETYPE="sources"

inherit kernel

OKV="2.4.20"
EXTRAVERSION="-gaming-r4"
KV="${OKV}${EXTRAVERSION}"
S=${WORKDIR}/linux-${KV}
CKV=4_2.4.20

DESCRIPTION="Full sources for the Gentoo gaming-optimized kernel"
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2 mirror://gentoo/patches-${KV}.tar.bz2 http://members.optusnet.com.au/ckolivas/kernel/ck${CKV}.patch.bz2"

KEYWORDS="-* ~x86"
SLOT="${KV}"

src_unpack() {
	unpack linux-${OKV}.tar.bz2 patches-${KV}.tar.bz2
	bzcat ${DISTDIR}/ck${CKV}.patch.bz2 | patch -p0 || die "-patch failed"

	mv linux-${OKV} linux-${KV} || die

	cd ${KV} || die #enter the patch directory and go!
	kernel_src_unpack
	echo "KV=${KV}" >/tmp/KV
}
