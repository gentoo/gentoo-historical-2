# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mips-sources/mips-sources-2.4.22-r3.ebuild,v 1.1 2003/10/16 03:22:07 kumba Exp $


ETYPE="sources"
inherit kernel eutils
OKV=${PV/_/-}
CVSDATE=20031015
KV=${OKV}-${CVSDATE}
S=${WORKDIR}/linux-${OKV}-${CVSDATE}
EXTRAVERSION=-mipscvs-${CVSDATE}
PROVIDE="virtual/linux-sources"


# What's in this kernel?

# INCLUDED:
# 1) linux sources from kernel.org
# 2) linux-mips.org CVS snapshot diff from 25 Sep 2003
# 3) patch to fix arch/mips[64]/Makefile to pass appropriate CFLAGS
# 4) patch to tweak arch/mips64/Makefile to pass -Wa,-mabi=o64 instead of -Wa,-32


DESCRIPTION="Linux-Mips CVS sources for MIPS-based machines, dated ${CVSDATE}"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://gentoo/mipscvs-${OKV}-${CVSDATE}.diff.bz2"
HOMEPAGE="http://www.linux-mips.org/"
KEYWORDS="-* ~mips"
SLOT="${OKV}"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/linux-${OKV} ${WORKDIR}/linux-${OKV}-${CVSDATE}
	cd ${S}

	# Update the vanilla sources with linux-mips CVS changes
	epatch ${WORKDIR}/mipscvs-${OKV}-${CVSDATE}.diff

	# Patch arch/mips/Makefile for gcc
	epatch ${FILESDIR}/mipscvs-${OKV}-makefile-fix.patch

	# Patch arch/mips64/Makefile to pass -Wa,mabi=o64
	epatch ${FILESDIR}/mipscvs-${OKV}-makefile-mips64-tweak.patch

	kernel_universal_unpack
}

pkg_postinst() {

	# Do kernel postinst stuff
	kernel_pkg_postinst

	# Create /usr/src/linux symlink
	ln -sf linux-${OKV}-${CVSDATE} ${ROOT}/usr/src/linux
}
