# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/kapow/kapow-1.4.2.ebuild,v 1.1 2012/09/11 16:06:45 jer Exp $

EAPI=4
inherit qt4-r2

DESCRIPTION="A punch clock program designed to easily keep track of your hours"
HOMEPAGE="http://gottcode.org/kapow/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 kapow.pro PREFIX=/usr
}

DOCS="ChangeLog README"
