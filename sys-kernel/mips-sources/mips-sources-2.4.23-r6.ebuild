# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mips-sources/mips-sources-2.4.23-r6.ebuild,v 1.4 2004/04/12 16:36:22 aliz Exp $


# Version Data
OKV=${PV/_/-}
CVSDATE="20031128"
EXTRAVERSION="-mipscvs-${CVSDATE}"
KV="${OKV}${EXTRAVERSION}"
COBALTPATCHVER="1.0"

# Miscellaneous stuff
S=${WORKDIR}/linux-${OKV}-${CVSDATE}
IUSE=""

# Eclass stuff
ETYPE="sources"
inherit kernel eutils


# INCLUDED:
# 1) linux sources from kernel.org
# 2) linux-mips.org CVS snapshot diff from 28 Nov 2003
# 3) patch to fix arch/mips[64]/Makefile to pass appropriate CFLAGS
# 4) XFS Patches for basic XFS support (with ACL, but no DMAPI)
# 5) do_brk fix
# 6) mremap fix
# 7) RTC fixes
# 8) Patches for Cobalt support


DESCRIPTION="Linux-Mips CVS sources for MIPS-based machines, dated ${CVSDATE}"
SRC_URI="mirror://kernel/linux/kernel/v2.4/linux-${OKV}.tar.bz2
		mirror://gentoo/mipscvs-${OKV}-${CVSDATE}.diff.bz2
		mirror://gentoo/cobalt-patches-24xx-${COBALTPATCHVER}.tar.bz2
		ftp://oss.sgi.com/projects/xfs/patches/2.4.23/xfs-2.4.23-split-only.bz2
		ftp://oss.sgi.com/projects/xfs/patches/2.4.23/xfs-2.4.23-split-kernel.bz2
		ftp://oss.sgi.com/projects/xfs/patches/2.4.23/xfs-2.4.23-split-acl.bz2"
HOMEPAGE="http://www.linux-mips.org/"
SLOT="${OKV}"
PROVIDE="virtual/linux-sources"
KEYWORDS="-* ~mips"


src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/linux-${OKV} ${WORKDIR}/linux-${OKV}-${CVSDATE}
	cd ${S}

	# Update the vanilla sources with linux-mips CVS changes
	epatch ${WORKDIR}/mipscvs-${OKV}-${CVSDATE}.diff

	# Patch arch/mips/Makefile for gcc (Pass -mips3/-mips4 for r4k/r5k cpus)
	epatch ${FILESDIR}/mipscvs-${OKV}-makefile-fix.patch

	# Patch to fix mips64 Makefile so that -finline-limit=10000 gets added to CFLAGS
	epatch ${FILESDIR}/mipscvs-${OKV}-makefile-inlinelimit.patch

	# MIPS RTC Fixes (Fixes memleaks, backport from 2.4.24)
	epatch ${FILESDIR}/rtc-fixes.patch

	# XFS Patches
	# We don't use epatch here because something funny is messed up in the XFS patches,
	# thus while they apply, they don't apply properly
	echo -e ""
	ebegin "Applying XFS Patchset"
		cat ${WORKDIR}/xfs-${PV}-split-only | patch -p1 2>&1 >/dev/null
		cat ${WORKDIR}/xfs-${PV}-split-kernel | patch -p1 2>&1 >/dev/null
		cat ${WORKDIR}/xfs-${PV}-split-acl | patch -p1 2>&1 >/dev/null
	eend

	# Security Fixes
	echo -e ""
	ebegin "Applying Security Fixes"
		epatch ${FILESDIR}/CAN-2003-0985-mremap.patch
		epatch ${FILESDIR}/CAN-2004-0010-ncpfs.patch
		epatch ${FILESDIR}/CAN-2004-0077-do_munmap.patch
	eend

	# Cobalt Patches
	if [ "${PROFILE_ARCH}" = "cobalt" ]; then
		echo -e ""
		einfo ">>> Patching kernel for Cobalt support ..."
		for x in ${WORKDIR}/cobalt-patches-24xx-${COBALTPATCHVER}/*.patch; do
			epatch ${x}
		done
		cp ${WORKDIR}/cobalt-patches-24xx-${COBALTPATCHVER}/cobalt-patches.txt ${S}
	fi

	kernel_universal_unpack
}
