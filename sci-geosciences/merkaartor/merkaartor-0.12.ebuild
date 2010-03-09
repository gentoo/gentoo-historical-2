# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/merkaartor/merkaartor-0.12.ebuild,v 1.5 2010/03/09 13:08:42 abcd Exp $

EAPI="1"

inherit eutils qt4

DESCRIPTION="A Qt4 based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.org"
SRC_URI="http://www.merkaartor.org/downloads/source/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"
DEPEND="x11-libs/qt-webkit:4
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	media-gfx/exiv2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_compile() {
	if use nls; then
		lrelease Merkaartor.pro || die "lrelease failed"
	fi
	eqmake4 Merkaartor.pro PREFIX=/usr GEOIMAGE=1 || die "qmake failed"
	emake || die "make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
	dodoc AUTHORS CHANGELOG HACKING || die "dodoc failed"

	doicon Icons/Mercator_100x100.png
	make_desktop_entry merkaartor "Merkaartor" Mercator_100x100 "Science;Geoscience"
}
