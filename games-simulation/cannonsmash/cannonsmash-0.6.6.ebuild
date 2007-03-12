# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/cannonsmash/cannonsmash-0.6.6.ebuild,v 1.13 2007/03/12 16:48:07 nyhm Exp $

inherit eutils games

MY_OGG=danslatristesse2-48.ogg
DESCRIPTION="3D tabletennis game"
HOMEPAGE="http://cannonsmash.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/csmash-${PV}.tar.gz
	vorbis? ( http://nan.p.utmc.or.jp/${MY_OGG} )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="vorbis nls"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	=x11-libs/gtk+-2*
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/csmash-${PV}

src_unpack() {
	unpack csmash-${PV}.tar.gz
	cd "${S}"
	epatch \
		"${FILESDIR}"/${P}-x-inc.patch \
		"${FILESDIR}"/${P}-sizeof-cast.patch \
		"${FILESDIR}"/${P}-gcc41.patch
	if use vorbis ; then
		sed -i \
			-e "s:${MY_OGG}:${GAMES_DATADIR}/csmash/${MY_OGG}:" ttinc.h \
			|| die "sed failed"
	fi
}

src_compile() {
	egamesconf \
		$(use_enable nls) \
		--datadir="${GAMES_DATADIR_BASE}" \
		|| die
	emake \
		localedir="/usr/share" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	if use vorbis ; then
		insinto "${GAMES_DATADIR}"/csmash
		doins "${DISTDIR}"/${MY_OGG} || die "doins failed"
	fi
	newicon win32/orange.ico ${PN}.ico
	make_desktop_entry csmash "Cannon Smash" /usr/share/pixmaps/${PN}.ico
	dodoc AUTHORS CREDITS README*
	prepgamesdirs
}
