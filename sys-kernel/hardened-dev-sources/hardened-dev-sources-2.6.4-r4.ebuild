# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/hardened-dev-sources/hardened-dev-sources-2.6.4-r4.ebuild,v 1.3 2004/05/20 02:23:02 lv Exp $

ETYPE="sources"
inherit kernel-2
detect_version

#version of hardened gentoo patchset
HGPV=4.4
HGPV_SRC="mirror://gentoo/hardened-patches-${KV_MAJOR}.${KV_MINOR}-${HGPV}.tar.bz2"

UNIPATCH_LIST="${DISTDIR}/hardened-patches-${KV_MAJOR}.${KV_MINOR}-${HGPV}.tar.bz2 	${FILESDIR}/hardened-dev-sources-2.6.5.CAN-2004-0109.patch"
UNIPATCH_DOCS="${WORKDIR}/patches/hardened-patches-${KV_MAJOR}.${KV_MINOR}-${HGPV}/0000_README"

DESCRIPTION="Hardened sources for the ${KV_MAJOR}.${KV_MINOR} kernel tree"

SRC_URI="${KERNEL_URI} ${HGPV_SRC}"
KEYWORDS="~x86 ~ppc ~sparc ~alpha -hppa amd64"
IUSE=""

pkg_postinst() {
	postinst_sources
}
