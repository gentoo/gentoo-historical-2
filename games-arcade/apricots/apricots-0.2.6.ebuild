# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/apricots/apricots-0.2.6.ebuild,v 1.4 2004/12/16 13:12:02 josejx Exp $

inherit games

DESCRIPTION="Fly a plane around bomb/shoot the enemy.  Port of Planegame from Amiga."
HOMEPAGE="http://www.fishies.org.uk/apricots.html"
SRC_URI="http://www.fishies.org.uk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~ppc"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/openal-20040303"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e 's:-DAP_PATH=\\\\\\"$prefix.*":-DAP_PATH=\\\\\\"${GAMES_DATADIR}/${PN}/\\\\\\"":' \
		configure.in \
		|| die "sed failed"

	sed -i \
		-e "s:filename(AP_PATH):filename(\"${GAMES_SYSCONFDIR}/${PN}/\"):" \
		${PN}/init.cpp \
		|| die "sed failed"
	sed -i \
		-e "s:apricots.cfg:${GAMES_SYSCONFDIR}/${PN}/apricots.cfg:" \
		README apricots.html \
		|| die "sed failed"
}

src_install() {
	dodoc AUTHORS INSTALL README TODO ChangeLog
	dohtml apricots.html
	cd ${PN}
	dogamesbin apricots || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}/${PN}"
	doins *.wav *.psf *.shapes || die "doins failed"
	insinto "${GAMES_SYSCONFDIR}/${PN}"
	doins apricots.cfg || die "failed to install game config file"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	einfo "You can change the game options by editing:"
	einfo "${GAMES_SYSCONFDIR}/${PN}/apricots.cfg"
	echo
}
