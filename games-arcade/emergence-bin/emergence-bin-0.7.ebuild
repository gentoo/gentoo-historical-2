# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/emergence-bin/emergence-bin-0.7.ebuild,v 1.1 2004/09/22 00:49:08 mr_bones_ Exp $

inherit games

MY_P="${P/-bin}"
DESCRIPTION="Network-only top down space arcade game"
HOMEPAGE="http://emergence.uk.net/"
SRC_URI="http://emergence.uk.net/pub/releases/${PV}/home.tbz2/${MY_P}-i686-linux-home.tbz2"

LICENSE="freedist"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""
RESTRICT="nostrip"

RDEPEND=">=sys-libs/zlib-1.2.1
	>=media-libs/libpng-1.2.5
	>=media-libs/libvorbis-1.0
	>=media-libs/alsa-lib-1.0.2
	virtual/x11"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodir "${GAMES_PREFIX_OPT}/${PN}" "${GAMES_BINDIR}" /usr/share
	cp -R * "${D}${GAMES_PREFIX_OPT}/${PN}" || die "cp failed"
	rm -rf "${D}${GAMES_PREFIX_OPT}/${PN}"/{applications,pixmaps}
	cp -R {applications,pixmaps} "${D}/usr/share" || die "cp failed"
	games_make_wrapper em-client em-client "${GAMES_PREFIX_OPT}/${PN}"
	games_make_wrapper em-server em-server "${GAMES_PREFIX_OPT}/${PN}"
	prepgamesdirs
}
