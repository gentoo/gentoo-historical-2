# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/hardened-sources/hardened-sources-2.6.14-r3.ebuild,v 1.1 2005/12/30 18:03:36 johnm Exp $

ETYPE="sources"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="7"

inherit kernel-2
detect_version
detect_arch

HGPV=${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}-3
HGPV_URI="mirror://gentoo/hardened-patches-${HGPV}.extras.tar.bz2"
UNIPATCH_LIST="${DISTDIR}/hardened-patches-${HGPV}.extras.tar.bz2"
DESCRIPTION="Hardened sources for the ${KV_MAJOR}.${KV_MINOR} kernel tree"

SRC_URI="${KERNEL_URI} ${HGPV_URI} ${GENPATCHES_URI} ${ARCH_URI}"
KEYWORDS="x86 ~ppc amd64 ~alpha"
