# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/moon-buggy/moon-buggy-1.0.51.ebuild,v 1.3 2009/03/18 22:40:18 ranger Exp $

EAPI=2
inherit autotools eutils games

DESCRIPTION="A simple console game, where you drive a car across the moon's surface"
HOMEPAGE="http://www.seehuhn.de/comp/moon-buggy.html"
SRC_URI="http://www.seehuhn.de/data/${P}.tar.gz
	esd? ( http://www.seehuhn.de/data/${PN}-sound-${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE="esd"

RDEPEND="esd? ( media-sound/esound )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -i \
		-e '/$(DESTDIR)$(bindir)\/moon-buggy -c/d' \
		Makefile.am \
		|| die "sed Makefile.am failed"
	use esd && epatch sound.patch
	rm -f missing
	eautoreconf
}

src_configure() {
	egamesconf --sharedstatedir="${GAMES_STATEDIR}"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ANNOUNCE AUTHORS ChangeLog NEWS README* TODO
	touch "${D}${GAMES_STATEDIR}"/${PN}/mbscore
	fperms 664 "${GAMES_STATEDIR}"/${PN}/mbscore
	prepgamesdirs
}
