# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/xmille/xmille-2.0.ebuild,v 1.5 2004/06/24 22:22:52 agriffis Exp $

inherit eutils games

DESCRIPTION="Mille Bournes card game"
HOMEPAGE=""
SRC_URI="mirror://debian/pool/main/x/xmille/${PN}_${PV}.orig.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/x11"

S="${WORKDIR}/${PN}-${PV}.orig"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PV}.patch"
}

src_compile() {
	xmkmf
	emake -j1 || die "emake failed"
}

src_install() {
	dogamesbin xmille || die "dogamesbin failed"
	dodoc CHANGES README
	newman xmille.man xmille.6
	prepgamesdirs
}
