# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-headers/linux-headers-2.6.8.1-r3.ebuild,v 1.1 2005/01/12 05:09:25 eradicator Exp $

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc sh x86"
inherit kernel-2

SRC_URI="${KERNEL_URI} mirror://gentoo/linux-2.6.8.1-sh-headers.patch.bz2"
# This version is just here to correspond to linux26-headers-2.6.8.1-r3 which
# was just created for amd64.
KEYWORDS="amd64"

UNIPATCH_LIST="${DISTDIR}/linux-2.6.8.1-sh-headers.patch.bz2
	${FILESDIR}/${PN}-2.6.0-sysctl_h-compat.patch
	${FILESDIR}/${PN}-2.6.0-fb.patch
	${FILESDIR}/${PN}-2.6.7-generic-arm-prepare.patch
	${FILESDIR}/${P}-strict-ansi-fix.patch
	${FILESDIR}/${P}-appCompat.patch
	${FILESDIR}/${P}-sparc-glibcsafe.patch
	${FILESDIR}/${PN}-soundcard-ppc64.patch
	${FILESDIR}/${P}-arm-float.patch
	${FILESDIR}/${P}-parisc-syscall.patch"

src_unpack() {
	kernel-2_src_unpack

	# Fixes ... all the mv magic is to keep sed from dumping 
	# ugly warnings about how it can't work on a directory.
	cd "${S}"/include
	mv asm-ia64/sn asm-ppc64/iSeries .
	headers___fix asm-ia64/*
	mv sn asm-ia64/
	headers___fix asm-ppc64/*
	mv iSeries asm-ppc64/
	headers___fix asm-ppc64/iSeries/*
}
