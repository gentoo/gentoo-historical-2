# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/legends/legends-0.3.6.ebuild,v 1.1 2003/12/13 09:34:20 mr_bones_ Exp $

inherit games

DESCRIPTION="A fast-paced first-person-perspective online multiplayer game similar to Tribes"
HOMEPAGE="http://hosted.tribalwar.com/legends/"
SRC_URI="http://themasters.co.za/${P}.tar.gz"

RESTRICT="nomirror"
KEYWORDS="~x86"
LICENSE="as-is"
SLOT="0"
IUSE="dedicated"

DEPEND=""
RDEPEND=">=media-libs/libsdl-1.2
	media-libs/openal"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm runlegends libSDL-*.so* libopenal.so
	find . -type f -exec chmod a-x '{}' \;
	chmod a+x ispawn lindedicated LinLegends
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	dodir ${dir}                           || die "dodir failed"
	cp -R * ${D}/${dir}/                   || die "cp failed"
	dogamesbin ${FILESDIR}/legends         || die "dogamesbin failed (1)"
	dosed "s:GENTOO_DIR:${dir}:" ${GAMES_BINDIR}/legends
	if use dedicated; then
		dogamesbin ${FILESDIR}/legends-ded || die "dogamesbin failed (2)"
		dosed "s:GENTOO_DIR:${dir}:" ${GAMES_BINDIR}/legends-ded
	fi
	prepgamesdirs
}
