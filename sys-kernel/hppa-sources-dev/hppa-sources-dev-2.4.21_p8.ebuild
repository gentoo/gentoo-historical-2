# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/hppa-sources-dev/hppa-sources-dev-2.4.21_p8.ebuild,v 1.2 2003/08/06 01:47:59 gmsoft Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

ETYPE="sources"
inherit kernel
OKV="${PV/_p*/}"
PATCH_LEVEL="-pa${PV/${OKV}_p/}"
EXTRAVERSION="${PATCH_LEVEL}-dev"
KV=${OKV}${EXTRAVERSION}
S=${WORKDIR}/linux-${KV}

# What's in this kernel?

# INCLUDED:
# stock 2.4.20 kernel sources
# patches for hppa
# security patches

PATCH_BASE="pa7"

GRSEC_V="1.9.11"


DESCRIPTION="Full sources for the Linux kernel with patch for hppa"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	http://ftp.parisc-linux.org/cvs/linux-2.4/patch-${OKV}-${PATCH_BASE}.diff.gz
	http://ftp.parisc-linux.org/cvs/linux-2.4/patch-${OKV}-${PATCH_BASE}${PATCH_LEVEL}.gz
	http://dev.gentoo.org/~gmsoft/patch-${OKV}${PATCH_LEVEL}-grsecurity-${GRSEC_V}.patch"

HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org/ http://parisc-linux.org" 
KEYWORDS="hppa -*"
SLOT="${KV}"


src_unpack() {
	unpack linux-${OKV}.tar.bz2
	mv ${WORKDIR}/linux-${OKV} ${WORKDIR}/linux-${KV}
	cd ${S}
	einfo Patching the kernel with the base patch
	zcat ${DISTDIR}/patch-${OKV}-${PATCH_BASE}.diff.gz | patch -p 1 || die Unable to patch the kernel
	einfo Patching the kernel with the final patch
	zcat ${DISTDIR}/patch-${OKV}-${PATCH_BASE}${PATCH_LEVEL}.gz | sed -e "s/Revision: 1.30/Revision: 1.31/" | patch -p 1 || die Unable to patch the kernel
	einfo Patching for grsecurity support
	cat ${DISTDIR}/patch-${OKV}${PATCH_LEVEL}-grsecurity-${GRSEC_V}.patch | patch -p 1 || die Unable to patch the kernel

	kernel_universal_unpack
}
