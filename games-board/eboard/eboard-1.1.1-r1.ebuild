# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/eboard/eboard-1.1.1-r1.ebuild,v 1.3 2010/05/24 19:01:22 pacho Exp $

EAPI=2
inherit eutils games

DEB_V=${PV}-4.1
EXTRAS1="eboard-extras-1pl2"
EXTRAS2="eboard-extras-2"
DESCRIPTION="chess interface for POSIX systems"
HOMEPAGE="http://www.bergo.eng.br/eboard/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/${EXTRAS1}.tar.gz
	mirror://sourceforge/${PN}/${EXTRAS2}.tar.gz
	mirror://debian/pool/main/e/eboard/${PN}_${DEB_V}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	media-libs/libpng
	dev-lang/perl
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch \
		"${WORKDIR}"/${PN}_${DEB_V}.diff \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-gcc44.patch
	sed -i \
		-e "s:(\"-O6\"):split(' ', \"${CXXFLAGS}\"):" \
		configure \
		|| die "sed configure failed"
}

src_configure() {
	# not an autoconf script
	./configure \
		--compiler="${CXX}" \
		--prefix="${GAMES_PREFIX}" \
		--data-prefix="${GAMES_DATADIR}" \
		--man-prefix="/usr/share/man" \
		$(use_enable nls) || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS ChangeLog TODO Documentation/*.txt

	newicon icon-eboard.xpm ${PN}.xpm
	make_desktop_entry ${PN} ${PN} ${PN}

	cd "${WORKDIR}"/${EXTRAS1}
	insinto "${GAMES_DATADIR}"/${PN}
	doins *.png *.wav || die "doins failed (extra1)"
	newins extras1.conf themeconf.extras1 || die "newins failed (extra1)"
	newdoc ChangeLog Changelog.extras
	newdoc README README.extras
	dodoc CREDITS

	cd "${WORKDIR}"/${EXTRAS2}
	doins *.png *.wav || die "doins failed (extra2)"
	newins extras2.conf themeconf.extras2 || die "newins failed (extra2)"

	prepgamesdirs
}
