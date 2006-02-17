# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/groundhog/groundhog-1.4.ebuild,v 1.13 2006/02/17 22:08:27 tupone Exp $

inherit eutils gnuconfig games

DESCRIPTION="Kids card/puzzle game"
HOMEPAGE="http://home-2.consunet.nl/~cb007736/groundhog.html"
SRC_URI="http://home-2.consunet.nl/~cb007736/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="nls"

DEPEND="=x11-libs/gtk+-2*"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-gcc3.patch
}

src_compile() {
	gnuconfig_update
	egamesconf $(use_enable nls) || die
	emake CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README NEWS AUTHORS TODO
	prepgamesdirs
}
