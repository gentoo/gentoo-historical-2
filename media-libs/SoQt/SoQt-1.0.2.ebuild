# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/SoQt/SoQt-1.0.2.ebuild,v 1.7 2005/07/21 15:33:07 caleb Exp $

DESCRIPTION="A Qt Interface for coin"
SRC_URI="ftp://ftp.coin3d.org/pub/coin/src/${P}.tar.gz"
HOMEPAGE="http://www.coin3d.org/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc"
IUSE=""

DEPEND="virtual/x11
	virtual/opengl
	<x11-libs/qt-4
	>=media-libs/coin-${PV}"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog* LICENSE* NEWS README*
	docinto txt
	dodoc docs/qtcomponents.doxygen
}
