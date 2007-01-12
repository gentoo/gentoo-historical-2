# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/rsbac-sources/rsbac-sources-2.6.19.ebuild,v 1.1 2007/01/12 13:35:35 kang Exp $

ETYPE="sources"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="5"

inherit kernel-2 unipatch-001
detect_version

RDEPEND="${RDEPEND}
	>=sys-apps/rsbac-admin-1.3.1"

HGPV=${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}-1
#HGPV_URI="mirror://gentoo/hardened-patches-${HGPV}.extras.tar.bz2"
HGPV_URI="mirror://gentoo/rsbac-hardened-patches-${HGPV}.extras.tar.bz2"
UNIPATCH_LIST="${DISTDIR}/rsbac-hardened-patches-${HGPV}.extras.tar.bz2"
DESCRIPTION="RSBAC Hardened sources for the ${KV_MAJOR}.${KV_MINOR} kernel tree"

SRC_URI="${KERNEL_URI} ${HGPV_URI} ${GENPATCHES_URI} ${ARCH_URI}"
KEYWORDS="~amd64 ~x86"

K_EXTRAEINFO="Guides are available from the Gentoo Documentation Project for
this kernel.
Please see http://www.gentoo.org/proj/en/hardened/rsbac/quickstart.xml
And the RSBAC hardened project http://www.gentoo.org/proj/en/hardened/rsbac/
For help setting up and using RSBAC."
