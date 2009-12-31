# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/peg-e/peg-e-1.1.0.ebuild,v 1.1 2009/12/31 23:02:06 ssuominen Exp $

EAPI=2
inherit eutils qt4 games

DESCRIPTION="A peg solitaire game"
HOMEPAGE="http://gottcode.org/peg-e/"
SRC_URI="http://gottcode.org/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-gui:4"

src_configure() {
	eqmake4
}

src_install() {
	dogamesbin ${PN} || die
	doicon icons/${PN}.png
	domenu icons/${PN}.desktop
	dodoc README
	prepgamesdirs
}
