# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/warzone2100/warzone2100-0.2.2.ebuild,v 1.1 2005/10/12 00:34:11 wolf31o2 Exp $

inherit eutils games

DESCRIPTION="Warzone 2100, the 3D real-time strategy game"
HOMEPAGE="http://warzone2100.sourceforge.net/"
SRC_URI="mirror://sourceforge/warzone2100/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mp3 ogg opengl"

DEPEND=">=media-libs/libsdl-1.2.8
	>=media-libs/sdl-net-1.2.5
	opengl? ( virtual/opengl )
	>=media-libs/openal-20040817
	ogg? ( >=media-libs/libvorbis-1.1.0 media-libs/libogg )
	mp3? ( >=media-libs/libmad-0.15 )"

src_unpack() {
	unpack ${A}

	sed s:DATADIR:"$GAMES_DATADIR"/${PN}/: \
		"${FILESDIR}"/${PV}-clparse.c.patch > \
		${T}/${PV}-clparse.c.patch \
	|| die "sed failed"

	sed -i 's: -m32::' ${S}/configure || die
	sed -i 's:-m32::' ${S}/makerules/common.mk || die

	cd ${S}
	epatch ${T}/${PV}-clparse.c.patch || die "epatch failed"
}

src_compile() {
	# $(use_with cda) ... cda disables ogg/mp3
	egamesconf \
		$(use_with opengl) \
		$(use_with ogg) \
		$(use_with mp3) \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CXXFLAGS}" \
	|| die "egamesconf failed"
	emake || die "emake failed"
}

src_install() {
	dogamesbin src/warzone || die "do executable failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/* || die "install data failed"
	dodoc AUTHORS CHANGELOG README || "install doc failed"

	prepgamesdirs
}
