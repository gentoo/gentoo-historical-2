# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-sources/gentoo-sources-2.6.10-r1.ebuild,v 1.1 2005/01/11 17:08:58 johnm Exp $

ETYPE="sources"
inherit kernel-2
detect_version
detect_arch

#version of gentoo patchset
GPV="10.01"
GPV_SRC="mirror://gentoo/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-base.tar.bz2
	mirror://gentoo/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-extras.tar.bz2"

KEYWORDS="~amd64 ~sparc ~x86 ~ppc64"

HOMEPAGE="http://dev.gentoo.org/~dsd/gentoo-dev-sources"

UNIPATCH_LIST="${DISTDIR}/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-base.tar.bz2
	       ${DISTDIR}/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-extras.tar.bz2"
UNIPATCH_DOCS="${WORKDIR}/patches/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}/0000_README"

DESCRIPTION="Full sources including the gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GPV_SRC} ${ARCH_URI}"

IUSE="ultra1"

pkg_setup() {
	if use sparc; then
		# hme lockup hack on ultra1
		use ultra1 || UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 1399_sparc-U1-hme-lockup.patch"

		# sparc32's Kconfig is broken by this patch... It'll be fixed soon, but use vanilla for now.
		[ "${PROFILE_ARCH}" = "sparc" ] && UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 1362_sparc-kconfig-rework.patch 1363_sparc-kconfig-driver-rework.patch"

		# Don't include features that don't work on sparc
		UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 4300_evms-dm-bbr.patch 4305_dm-multipath.patch 4306_dm-mp-version.patch 4500_fbsplash-0.9.1.patch 4905_speakup-20041020.patch"
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
