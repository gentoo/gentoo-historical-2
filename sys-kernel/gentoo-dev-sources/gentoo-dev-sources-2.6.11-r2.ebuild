# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-dev-sources/gentoo-dev-sources-2.6.11-r2.ebuild,v 1.2 2005/03/04 22:05:35 hansmi Exp $

ETYPE="sources"
IUSE="ultra1"
inherit kernel-2
detect_version
detect_arch

#version of gentoo patchset
GPV="11.02"
GPV_SRC="http://reactivated.net/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-base.tar.bz2
	http://reactivated.net/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-extras.tar.bz2"

KEYWORDS="~x86 ~amd64 ~ppc64 ~ppc"

HOMEPAGE="http://dev.gentoo.org/~dsd/gentoo-dev-sources"

UNIPATCH_LIST="${DISTDIR}/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-base.tar.bz2
	       ${DISTDIR}/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-extras.tar.bz2"
UNIPATCH_DOCS="${WORKDIR}/patches/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}/0000_README"

DESCRIPTION="Full sources including the gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GPV_SRC} ${ARCH_URI}"


pkg_setup() {
	if use sparc; then
		# hme lockup hack on ultra1
		use ultra1 || UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 1399_sparc-U1-hme-lockup.patch"
	fi
}

pkg_postinst() {
	postinst_sources

	echo

	if [ "${ARCH}" = "sparc" ]; then
		if [ x"`cat /proc/openprom/name 2>/dev/null`" \
			 = x"'SUNW,Ultra-1'" ]; then
			einfo "For users with an Enterprise model Ultra 1 using the HME"
			einfo "network interface, please emerge the kernel using the"
			einfo "following command: USE=ultra1 emerge ${PN}"
		fi
	fi
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
