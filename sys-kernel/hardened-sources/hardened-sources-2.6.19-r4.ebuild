# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/hardened-sources/hardened-sources-2.6.19-r4.ebuild,v 1.1 2007/01/14 05:35:01 phreak Exp $

ETYPE="sources"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="5"

inherit kernel-2
detect_version

HGPV=${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}-5
HGPV_URI="mirror://gentoo/hardened-patches-${HGPV}.extras.tar.bz2"
UNIPATCH_LIST="${DISTDIR}/hardened-patches-${HGPV}.extras.tar.bz2"
UNIPATCH_EXCLUDE="4453_grsec-2.1.9-2.6.19-io-kmem-sysctl.patch"
DESCRIPTION="Hardened kernel sources ${OKV}"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/"

SRC_URI="${KERNEL_URI} ${HGPV_URI} ${GENPATCHES_URI} ${ARCH_URI}"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
