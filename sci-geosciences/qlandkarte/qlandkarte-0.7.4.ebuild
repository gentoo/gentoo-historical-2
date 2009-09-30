# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/qlandkarte/qlandkarte-0.7.4.ebuild,v 1.2 2009/09/30 16:44:49 ayoy Exp $

EAPI="1"

inherit autotools eutils qt4

DESCRIPTION="View and upload map files, track and waypoint data to your Garmin GPS."
HOMEPAGE="http://qlandkarte.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/QLandkarte_final.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	sci-libs/proj
	dev-libs/libusb"
RDEPEND="${DEPEND}"

S="${WORKDIR}/QLandkarte_final"

src_unpack() {
	unpack ${A}
	cd "${S}"
	eautoreconf || die "eautoreconf failed"
}

src_compile() {
	econf || die "econf failed"
	eqmake4 QLandkarte.pro || die "eqmake4 failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
}
