# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ac-sources/ac-sources-2.4.20-r2.ebuild,v 1.1 2002/12/13 19:58:10 lostlogic Exp $

IUSE="build"

# OKV=original kernel version, KV=patched kernel version.  

ETYPE="sources"

inherit kernel || die

OKV="2.4.20"
ACV=ac${PR/r/}
KV="${PV/_/-}-${ACV}"
S=${WORKDIR}/linux-${KV}

EXTRAVERSION="`echo ${KV}|sed -e 's:[^-]*\(-.*$\):\1:'`"
BASE="`echo ${KV}|sed -e s:${EXTRAVERSION}::`"

DESCRIPTION="Full sources for Alan Cox's Linux kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
http://www.kernel.org/pub/linux/kernel/people/alan/linux-2.4/${BASE}/patch-${KV}.bz2"
#add to src_uri for pre/rc patch ac-sources
#http://www.kernel.org/pub/linux/kernel/v2.4/testing/patch-${PV/_/-}.bz2

KEYWORDS="x86"

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	mv linux-${OKV} linux-${KV} || die

	cd linux-${KV}
#	Uncomment for pre/rc patch versions
#	bzcat ${DISTDIR}/patch-${PV/_/-}.bz2|patch -p1 || die "-marcelo patch failed"
	bzcat ${DISTDIR}/patch-${KV}.bz2|patch -p1 || die "-ac patch failed"

	kernel_universal_unpack
}
