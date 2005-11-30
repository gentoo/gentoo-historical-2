# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/allegrogl/allegrogl-0.2.4.ebuild,v 1.1.1.1 2005/11/30 10:03:37 chriswhite Exp $

inherit eutils

MY_PN="alleggl"
DESCRIPTION="A library to mix OpenGL graphics with Allegro routines"
HOMEPAGE="http://allegrogl.sourceforge.net"
SRC_URI="mirror://sourceforge/allegrogl/${MY_PN}-${PV}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE="doc"

DEPEND=">=media-libs/allegro-4.0.0"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-destdir.patch"
}

src_compile() {
	econf || die
	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc *txt
	use doc && dodoc examp/*
}
