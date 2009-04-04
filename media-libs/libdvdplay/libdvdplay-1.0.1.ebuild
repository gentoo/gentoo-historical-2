# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdplay/libdvdplay-1.0.1.ebuild,v 1.22 2009/04/04 20:10:00 solar Exp $

inherit libtool

IUSE=""

DESCRIPTION="A simple library designed for DVD-menu navigation"
SRC_URI="http://www.videolan.org/pub/${PN}/${PV}/${P}.tar.bz2"
HOMEPAGE="http://developers.videolan.org/libdvdplay/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~arm alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"

DEPEND=">=media-libs/libdvdread-0.9.3"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Needed to get a sane .so versionning on fbsd, please don't drop it.
	elibtoolize
}

src_compile() {
	econf --enable-shared || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
