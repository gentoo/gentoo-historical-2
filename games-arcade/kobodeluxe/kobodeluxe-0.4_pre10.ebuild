# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/kobodeluxe/kobodeluxe-0.4_pre10.ebuild,v 1.5 2004/06/24 22:06:45 agriffis Exp $

inherit flag-o-matic games

MY_P="KoboDeluxe-${PV/_/}"
DESCRIPTION="An SDL port of xkobo, a addictive space shoot-em-up"
HOMEPAGE="http://www.olofson.net/kobodl/"
SRC_URI="http://www.olofson.net/kobodl/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="opengl"

RDEPEND="virtual/glibc
	media-libs/libsdl
	media-libs/sdl-image
	opengl? ( virtual/opengl )"
DEPEND="$RDEPEND
	>=sys-apps/sed-4"

S=${WORKDIR}/${MY_P}

src_unpack() {
	filter-flags -fforce-addr
	unpack ${A}
	cd ${S}
	# Fix paths
	sed -i \
		-e 's:\$(datadir)/games/kobo-deluxe:$(datadir)/kobodeluxe:' \
		-e 's:\$(prefix)/games/kobo-deluxe/scores:$(localstatedir)/kobodeluxe:' \
		configure || die "sed configure failed"
	sed -i \
		-e 's:\$(datadir)/games/kobo-deluxe:$(datadir)/kobodeluxe:' \
		data/Makefile.in || die "sed data/Makefile.in failed"
}

src_compile() {
	egamesconf $(use_enable opengl) || die
	emake || die "emake failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog README* TODO

	insinto "${GAMES_STATEDIR}/${PN}"
	doins 501 || die "doins failed"
	prepgamesdirs
	fperms 2775 "${GAMES_STATEDIR}/${PN}"
}

pkg_postinst() {
	games_pkg_postinst
	einfo "The location of the highscore files has changed.  If this isn't the"
	einfo "first time you've installed ${PN} and you'd like to keep the high"
	einfo "scores from a previous version of ${PN}, please move all the files"
	einfo "in /var/lib/games/kobodeluxe/ to ${GAMES_STATEDIR}/${PN}. If you"
	einfo "have a /var/lib/games/kobodeluxe/ directory it may be removed."
}
