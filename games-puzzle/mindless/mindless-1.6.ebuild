# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/mindless/mindless-1.6.ebuild,v 1.3 2005/07/23 22:01:37 mr_bones_ Exp $

inherit games

ORANAME="OracleAll_050523.txt"
DESCRIPTION="play collectable/trading card games (Magic: the Gathering and possibly others) against other people"
HOMEPAGE="http://mindless.sourceforge.net/"
SRC_URI="mirror://sourceforge/mindless/${P}.tar.gz
	http://www.wizards.com/dci/oracle/${ORANAME}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
RESTRICT="mirror" # for the card database

RDEPEND=">=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	gnome-base/librsvg
	dev-util/pkgconfig"

src_unpack() {
	unpack "${P}.tar.gz"
	cp "${DISTDIR}/${ORANAME}" "${WORKDIR}" || die "cp failed"
	DATAFILE="${GAMES_DATADIR}/${PN}/${ORANAME}"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dogamesbin mindless || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins "${WORKDIR}/${ORANAME}" || die "doins failed"
	dodoc CHANGES README TODO
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	einfo "The first time you start ${PN} you need to tell it where to find"
	einfo "the text database of cards.  This file has been installed at:"
	einfo "${DATAFILE}"
	echo
}
