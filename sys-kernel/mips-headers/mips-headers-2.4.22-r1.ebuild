# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mips-headers/mips-headers-2.4.22-r1.ebuild,v 1.6 2003/11/16 11:09:40 kumba Exp $


OKV=${PV/_/-}
CVSDATE=20030825
S=${WORKDIR}/linux-${OKV}
EXTRAVERSION=-mipscvs-${CVSDATE}
KV="${OKV}${EXTRAVERSION}"
ETYPE="headers"
inherit kernel

# What's in this kernel?

# INCLUDED:
# 1) linux sources from kernel.org
# 2) linux-mips.org CVS snapshot diff from 25 Aug 2003
# 3) patch to fix arch/mips[64]/Makefile to pass appropriate CFLAGS

DESCRIPTION="Linux-Mips CVS headers for MIPS-based machines"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://gentoo/mipscvs-${OKV}-${CVSDATE}.diff.bz2"
HOMEPAGE="http://www.linux-mips.org/"
SLOT="0"
PROVIDE="virtual/os-headers"
KEYWORDS="-*"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Update the vanilla sources with linux-mips CVS changes
	cat ${WORKDIR}/mipscvs-${OKV}-${CVSDATE}.diff | patch -p1

	# Big Endian Fix
	cat ${FILESDIR}/bigendian-byteorder-fix.patch | patch -p1

	# Patch arch/mips/Makefile for gcc
	cat ${FILESDIR}/mipscvs-${OKV}-${CVSDATE}-makefile-fix.patch | patch -p0

	kernel_universal_unpack
}
