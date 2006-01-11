# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ck-sources/ck-sources-2.6.15_p1-r1.ebuild,v 1.1 2006/01/11 23:31:54 marineam Exp $

K_PREPATCHED="yes"
UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="2"
ETYPE="sources"
inherit kernel-2
detect_version

# A few hacks to set ck version via _p instead of -r
MY_P=${P/_p*/}
MY_PR=${PR/r/-r}
MY_PR=${MY_PR/-r0/}
EXTRAVERSION=-ck${PV/*_p/}${MY_PR}
KV_FULL=${OKV}${EXTRAVERSION}
KV_CK=${KV_FULL/-r*/}
detect_version

IUSE="ck-server"
if use ck-server; then
	CK_PATCH="patch-${KV_CK/ck/cks}.bz2"
else
	CK_PATCH="patch-${KV_CK}.bz2"
fi

UNIPATCH_LIST="${DISTDIR}/${CK_PATCH}"

DESCRIPTION="Full sources for the Linux kernel with Con Kolivas' high
performance patchset and Gentoo's basic patchset."
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI}
	ck-server? (
	http://ck.kolivas.org/patches/cks/patch-${KV_CK/ck/cks}.bz2
	)
	!ck-server? (
	http://ck.kolivas.org/patches/2.6/${OKV}/${KV_CK}/patch-${KV_CK}.bz2 )"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

pkg_postinst() {
	postinst_sources

	einfo "The ck patchset is tuned for desktop usage."
	einfo "To better tune the kernel for server applications add"
	einfo "ck-server to your use flags and reemerge ck-sources"
}

