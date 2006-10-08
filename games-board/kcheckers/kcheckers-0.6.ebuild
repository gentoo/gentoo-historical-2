# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/kcheckers/kcheckers-0.6.ebuild,v 1.5 2006/10/08 21:28:32 nyhm Exp $

inherit qt3 games

DESCRIPTION="Qt version of the classic boardgame checkers"
HOMEPAGE="http://kcheckers.org/"
SRC_URI="http://kcheckers.org/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="$(qt_min_version 3.3)"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i "s:/usr/local/share:${GAMES_DATADIR}:" \
		config.h || die "sed failed"
}

src_compile() {
	"${QTDIR}"/bin/qmake || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin kcheckers || die "dogamesbin failed"
	dodoc AUTHORS ChangeLog README TODO

	insinto "${GAMES_DATADIR}"/${PN}
	doins i18n/* kcheckers.pdn || die "doins failed"

	prepgamesdirs
}
