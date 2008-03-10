# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmplot/kmplot-4.0.2.ebuild,v 1.1 2008/03/10 23:45:20 philantrop Exp $

EAPI="1"

KMNAME=kdeedu
inherit kde4-meta

DESCRIPTION="Mathematical function plotter for KDE"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND=">=kde-base/knotify-${PV}:${SLOT}"
