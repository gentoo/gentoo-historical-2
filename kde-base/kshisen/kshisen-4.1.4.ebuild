# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kshisen/kshisen-4.1.4.ebuild,v 1.1 2009/01/13 22:47:11 alexxy Exp $

EAPI="2"

KMNAME=kdegames
inherit kde4-meta

DESCRIPTION="A KDE game similiar to Mahjongg"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug htmlhandbook"

DEPEND=">=kde-base/libkmahjongg-${PV}:${SLOT}"
RDEPEND="${DEPEND}"
