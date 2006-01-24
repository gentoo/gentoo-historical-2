# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/scribus/scribus-1.3.2-r1.ebuild,v 1.1 2006/01/24 01:51:18 hanno Exp $

inherit qt3 eutils

DESCRIPTION="Desktop Publishing (DTP) and Layout program for Linux."
HOMEPAGE="http://www.scribus.net"
SRC_URI="http://www.scribus.org.uk/downloads/${PV}/${P}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~ppc64"
IUSE="cairo"

DEPEND="$(qt_min_version 3.3.4)
	>=media-libs/freetype-2.1
	>=media-libs/lcms-1.09
	media-libs/tiff
	>=media-libs/libart_lgpl-2.3.8
	>=sys-devel/gcc-3.0.0
	>=dev-libs/libxml2-2.6.0
	cairo? ( >=x11-libs/cairo-1.0 )"

RDEPEND="${DEPEND}
	virtual/ghostscript"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-fixes.diff
}

src_compile() {
	econf `use_enable cairo` || die
	emake CXXFLAGS="${CXXFLAGS} -I/usr/include/lcms" || die
}

src_install() {
	einstall destdir=${D} || die

	dodoc AUTHORS ChangeLog README TODO

	domenu scribus.desktop
	doicon scribus/icons/scribusicon.png

	mkdir -p ${D}/usr/share/doc/${P}
	mv ${D}/usr/share/scribus/doc ${D}/usr/share/doc/${P}/html
}
