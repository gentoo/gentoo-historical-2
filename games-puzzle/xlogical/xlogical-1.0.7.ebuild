# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/xlogical/xlogical-1.0.7.ebuild,v 1.2 2007/01/12 04:02:41 mr_bones_ Exp $

inherit versionator eutils games

MY_PV=$(replace_version_separator 2 '-' )
MY_P=${PN}-${MY_PV}

DESCRIPTION="SDL logical clone"
HOMEPAGE="http://changeling.ixionstudios.com/xlogical/"
SRC_URI="http://changeling.ixionstudios.com/xlogical/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-2)

src_unpack() {
	unpack ${A}
	cd "${S}"
	edos2unix properties.h anim.h exception.h
	epatch "${FILESDIR}/${P}"-gcc41.patch
}

src_install() {
	dogamesbin ${PN} || die "installing the binary failed"

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r ${PN}.{properties,levels} music sound images \
		 || die "installing game data failed"

	insinto "${GAMES_STATEDIR}"/${PN}
	insopts -m0660
	doins ${PN}.scores || die "installing hi-score failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
	prepgamesdirs
}
