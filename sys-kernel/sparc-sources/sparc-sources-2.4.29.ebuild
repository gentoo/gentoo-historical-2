# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/sparc-sources/sparc-sources-2.4.29.ebuild,v 1.4 2005/03/06 19:21:57 gustavoz Exp $

ETYPE="sources"
IUSE="livecd ultra1"
inherit kernel-2
detect_version

PATCH_BASE="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}${EXTRAVERSION}"

SSV_URI="mirror://gentoo/patches-${PATCH_BASE}.tar.bz2"

KEYWORDS="-* sparc"
DESCRIPTION="Full sources for the Gentoo Sparc Linux kernel"
UNIPATCH_LIST="${DISTDIR}/patches-${PATCH_BASE}.tar.bz2
	${FILESDIR}/2.4-sparc64-ramdisk64.patch
	${FILESDIR}/blade1500.patch"
SRC_URI="${KERNEL_URI} ${SSV_URI}"
HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org"

pkg_setup() {
	use ultra1 || UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 2000_U1-hme-lockup.patch"
	use livecd || UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE}
	2.4-sparc64-ramdisk64.patch"
}

pkg_postinst() {
	postinst_sources

	if [ ! -r "/proc/openprom/name" -o "cat /proc/openprom/name 2>/dev/null" = "'SUNW,Ultra-1'" ]; then
		einfo
		einfo "For users with an Enterprise model Ultra 1 using the HME network interface,"
		einfo "please emerge the kernel using the following command:"
		einfo
		einfo "USE=ultra1 emerge sparc-sources"
		einfo
	fi

}
