# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmplot/kmplot-4.2.1.ebuild,v 1.1 2009/03/04 21:52:05 alexxy Exp $

EAPI="2"

KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="Mathematical function plotter for KDE"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug"

RDEPEND=">=kde-base/knotify-${PV}:${SLOT}"
