# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/aa-sources/aa-sources-2.4.20-r1.ebuild,v 1.1 2002/12/06 23:17:56 lostlogic Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  

ETYPE="sources"

inherit kernel || die

OKV="2.4.20"
AAV=aa${PR/r/}
KV="${PV/_/-}-${AAV}"
S=${WORKDIR}/linux-${KV}

EXTRAVERSION="`echo ${KV}|sed -e 's:[^-]*\(-.*$\):\1:'`"
BASE="`echo ${KV}|sed -e s:${EXTRAVERSION}::`"

DESCRIPTION="Full sources for Andrea Arcangeli's Linux kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
http://www.kernel.org/pub/linux/kernel/people/andrea/kernels/v2.4/${KV//-/}.bz2"
#Add this to the src_uri for _pre kernels...
#http://www.kernel.org/pub/linux/kernel/v2.4/testing/patch-${PV/_/-}.bz2

KEYWORDS="x86"

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	mv linux-${OKV} linux-${KV} || die

	cd linux-${KV}

#	uncomment this for _pre kernels...
#	bzcat ${DISTDIR}/patch-${PV/_/-}.bz2|patch -p1 || die "-marcelo patch failed"
	bzcat ${DISTDIR}/${KV//-/}.bz2|patch -p1 || die "-aa patch failed"

	kernel_universal_unpack
}

