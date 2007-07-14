# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ck-sources/ck-sources-2.6.21_p2.ebuild,v 1.2 2007/07/14 23:11:23 mr_bones_ Exp $

DESCRIPTION="Full sources for the Linux kernel with Con Kolivas' high performance patchset and Gentoo's basic patchset."
HOMEPAGE="http://members.optusnet.com.au/ckolivas/kernel/"
IUSE="ck-server"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

K_NOUSENAME="yes"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="2"
UNIPATCH_STRICTORDER="1"
ETYPE="sources"
inherit kernel-2

detect_version
# A few hacks to set ck version via _p instead of -r
MY_PR=${PR/r/-r}
MY_PR=${MY_PR/-r0/}
EXTRAVERSION=-ck${PV/*_p/}${MY_PR}
KV_FULL=${OKV}${EXTRAVERSION}
KV_CK=${KV_FULL/-r*/}

CKPATCH="patch-${KV_CK}.bz2"

if use ck-server; then
	UNIPATCH_LIST="${DISTDIR}/${CKPATCH/ck/cks}"
else
	UNIPATCH_LIST="${DISTDIR}/${CKPATCH}"
fi

# Note: 2.6.x.y updates in genpatches begin with 10 but are included in -ck
#UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI}
	ck-server? (
	mirror://kernel/linux/kernel/people/ck/patches/2.6/${OKV}/${KV_CK}/${CKPATCH/ck/cks}
	)
	!ck-server? (
	mirror://kernel/linux/kernel/people/ck/patches/2.6/${OKV}/${KV_CK}/${CKPATCH} )"

pkg_postinst() {
	postinst_sources

	einfo "The ck patchset is tuned for desktop usage."
	einfo "To better tune the kernel for server applications add"
	einfo "ck-server to your use flags and reemerge ck-sources"
}
