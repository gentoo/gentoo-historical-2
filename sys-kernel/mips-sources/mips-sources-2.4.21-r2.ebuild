# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mips-sources/mips-sources-2.4.21-r2.ebuild,v 1.6 2003/12/02 03:56:45 iggy Exp $

ETYPE="sources"
inherit kernel

OKV=${PV/_/-}
CVSDATE=20030803
S=${WORKDIR}/linux-${OKV}
EXTRAVERSION=-mipscvs-${CVSDATE}
KV="${OKV}${EXTRAVERSION}"

# What's in this kernel?

# INCLUDED:
# 1) linux sources from kernel.org
# 2) linux-mips.org CVS snapshot diff from 03 Aug 2003
# 3) patch to fix arch/mips/Makefile to pass appropriate CFLAGS

DESCRIPTION="Linux-Mips CVS sources for MIPS-based machines"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://gentoo/mipscvs-${OKV}-${CVSDATE}.diff.bz2"
HOMEPAGE="http://www.linux-mips.org/"
SLOT="${OKV}"
PROVIDE="virtual/linux-sources"
KEYWORDS="-* mips"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Update the vanilla sources with linux-mips CVS changes
	cat ${WORKDIR}/mipscvs-${OKV}-${CVSDATE}.diff | patch -p1

	# Big Endian Fix
	cat ${FILESDIR}/bigendian-byteorder-fix.patch | patch -p1

	# Patch arch/mips/Makefile for gcc
	cat ${FILESDIR}/mipscvs-${OKV}-makefile-fix.patch | patch -p0

	epatch ${FILESDIR}/do_brk_fix.patch || die "failed to patch for do_brk vuln"

	kernel_universal_unpack
}
