# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/gentoo-dev-sources/gentoo-dev-sources-2.6.4-r1.ebuild,v 1.6 2004/07/15 03:48:34 agriffis Exp $

ETYPE="sources"
inherit kernel-2
detect_version

#version of gentoo patchset
GPV=4.27
GPV_SRC="mirror://gentoo/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}.tar.bz2"

KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

UNIPATCH_LIST="${DISTDIR}/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}.tar.bz2"
UNIPATCH_DOCS="${WORKDIR}/patches/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}/README"

DESCRIPTION="Full sources including the gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GPV_SRC}"

DEPEND="${DEPEND} >=dev-libs/ucl-1"

pkg_postinst() {
	postinst_sources

	ewarn "If you choose to use UCL/gcloop please ensure you compile gcloop"
	ewarn "without -fstack-protector."
	echo
}
