# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/openmosix-sources/openmosix-sources-2.4.26.ebuild,v 1.3 2004/07/15 03:54:35 agriffis Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

ETYPE="sources"
inherit kernel

OKV="2.4.26"
TIMESTAMP="20040415"
[ "${PR}" == "r0" ] && KV=${PV/_/-}-openmosix || KV=${PV/_/-}-openmosix-${PR}
EXTRAVERSION="`echo ${KV}|sed -e 's:[0-9]\+\.[0-9]\+\.[0-9]\+\(.*\):\1:'`"
BASE="`echo ${KV}|sed -e s:${EXTRAVERSION}::`"
S=${WORKDIR}/linux-${KV}

# What's in this kernel?

# INCLUDED:
#   ${OKV}, plus:
#   ${OKV}  openmosix-${OKV}-${TIMESTAMP} by tab

DESCRIPTION="Full sources for the Gentoo openMosix Linux kernel"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2 http://openmosix.snarc.org/download/testing/patch-${OKV}-om-${TIMESTAMP}.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://www.kernel.org/ http://www.openmosix.org/ http://openmosix.snarc.org/download/"
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="-*"
IUSE=""

src_unpack() {
	unpack linux-${OKV}.tar.bz2
	mv linux-${OKV} linux-${KV} || die
	cd linux-${KV}
	bzcat ${DISTDIR}/patch-${OKV}-om-${TIMESTAMP}.bz2 | patch -p1 || die "-openmosix patch failed"
	kernel_universal_unpack
}
