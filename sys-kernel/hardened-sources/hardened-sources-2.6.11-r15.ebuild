# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/hardened-sources/hardened-sources-2.6.11-r15.ebuild,v 1.1.1.1 2005/11/30 09:49:39 chriswhite Exp $

ETYPE="sources"
inherit kernel-2
detect_version

#[[ ${PR//r} == 0 ]] && GPV=1 || GPV=${PR//r}
GPV=14
GPV=${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}-${GPV}
#HGPV=${GPV}
HGPV=${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}-15
GPV_SRC="mirror://gentoo/genpatches-${GPV}.base.tar.bz2"
HGPV_SRC="mirror://gentoo/hardened-patches-${HGPV}.extras.tar.bz2"

UNIPATCH_LIST="${DISTDIR}/genpatches-${GPV}.base.tar.bz2
			   ${DISTDIR}/hardened-patches-${HGPV}.extras.tar.bz2"
DESCRIPTION="Hardened sources for the ${KV_MAJOR}.${KV_MINOR} kernel tree"

SRC_URI="${KERNEL_URI} ${HGPV_SRC} ${GPV_SRC}"
KEYWORDS="x86 ppc amd64"
