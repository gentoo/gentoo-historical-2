# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/hardened-dev-sources/hardened-dev-sources-2.6.7-r7.ebuild,v 1.1 2004/08/10 03:17:59 tseng Exp $

IUSE=""
ETYPE="sources"
inherit kernel-2
detect_version

GPV=7.45
GPV_SRC="mirror://gentoo/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-base.tar.bz2"

HGPV=7.6
#HGPV_SRC="mirror://gentoo/hardened-patches-${KV_MAJOR}.${KV_MINOR}-${HGPV}.tar.bz2"
HGPV_SRC="http://dev.gentoo.org/~tseng/kernel/hardened-patches-${KV_MAJOR}.${KV_MINOR}-${HGPV}.tar.bz2"

UNIPATCH_STRICTORDER="yes"
UNIPATCH_EXCLUDE="1315_alpha"
UNIPATCH_LIST="${DISTDIR}/hardened-patches-${KV_MAJOR}.${KV_MINOR}-${HGPV}.tar.bz2
	${DISTDIR}/genpatches-${KV_MAJOR}.${KV_MINOR}-${GPV}-base.tar.bz2"
UNIPATCH_DOCS="${WORKDIR}/patches/hardened-patches-${KV_MAJOR}.${KV_MINOR}-${HGPV}/0000_README"

DESCRIPTION="Hardened sources for the ${KV_MAJOR}.${KV_MINOR} kernel tree"

SRC_URI="${KERNEL_URI} ${HGPV_SRC} ${GPV_SRC}"
KEYWORDS="x86 ~ppc amd64"

pkg_postinst() {
	postinst_sources
}
