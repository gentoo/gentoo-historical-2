# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-kids/pytraffic/pytraffic-2.5.4.ebuild,v 1.2 2007/04/26 08:45:33 nyhm Exp $

inherit distutils eutils games

DESCRIPTION="Python version of the board game Rush Hour"
HOMEPAGE="http://alpha.uhasselt.be/Research/Algebra/Members/pytraffic/"
SRC_URI="http://alpha.uhasselt.be/Research/Algebra/Members/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}
	dev-python/pygtk"

src_compile() {
	distutils_src_compile
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r doc config.db extra_themes icons libglade music sound_test \
		themes *.py ttraffic.levels || die "doins failed"

	exeinto "$(games_get_libdir)"/${PN}
	doexe build/*/{_hint,_sdl_mixer}.so || die "doexe failed"
	dosym {"$(games_get_libdir)","${GAMES_DATADIR}"}/${PN}/_hint.so \
		|| die "dosym _hint.so failed"
	dosym {"$(games_get_libdir)","${GAMES_DATADIR}"}/${PN}/_sdl_mixer.so \
		|| die "dosym _sdl_mixer.so failed"

	games_make_wrapper ${PN} "python ./Main.py" "${GAMES_DATADIR}"/${PN}
	doicon icons/64x64/${PN}.png
	make_desktop_entry ${PN} PyTraffic

	dodoc AUTHORS CHANGELOG README

	rm -f "${D}/${GAMES_DATADIR}"/${PN}/setup.py
	prepgamesdirs
}

pkg_postinst() {
	distutils_pkg_postinst
	games_pkg_postinst
}
