# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/cutecom/cutecom-0.20.0-r1.ebuild,v 1.6 2009/10/06 17:17:52 ayoy Exp $

EAPI=1

inherit eutils qt4 cmake-utils

DESCRIPTION="CuteCom is a serial terminal, like minicom, written in qt"
HOMEPAGE="http://cutecom.sourceforge.net"
SRC_URI="http://cutecom.sourceforge.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-qt3support:4"
RDEPEND="${DEPEND}
	net-dialup/lrzsz"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${P}-manpath.patch
}
