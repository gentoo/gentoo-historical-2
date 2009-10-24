# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wxdfast/wxdfast-0.6.0-r1.ebuild,v 1.2 2009/10/24 05:36:17 dirtyepic Exp $

EAPI="2"

WX_GTK_VER="2.8"

inherit autotools eutils wxwidgets

DESCRIPTION="A multi-threaded cross-platform download manager"
HOMEPAGE="http://dfast.sourceforge.net"
SRC_URI="mirror://sourceforge/dfast/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/wxGTK:2.8"
RDEPEND="${DEPEND}"

pkg_setup() {
	need-wxwidgets unicode
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-wxrc-configure.patch
	epatch "${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog TODO
}
