# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/emilia-pinball/emilia-pinball-0.3.0.ebuild,v 1.9 2005/01/18 04:35:24 weeve Exp $

inherit games

MY_PN=${PN/emilia-/}
MY_P=${MY_PN}-${PV}
DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="http://pinball.sourceforge.net/"
SRC_URI="mirror://sourceforge/pinball/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha"
IUSE=""

RDEPEND="virtual/opengl
	virtual/x11
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.58"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	export WANT_AUTOCONF=2.5
	cd ${S}/libltdl
	autoconf || die
}

src_compile() {
	egamesconf \
		--with-x \
		--with-buildroot-prefix=${D} \
		|| die
	make CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dodoc AUTHORS Changelog INSTALL NEWS README
	make DESTDIR=${D} install || die
	dosym ${GAMES_BINDIR}/pinball ${GAMES_BINDIR}/emilia-pinball
	rm -rf ${D}/${GAMES_PREFIX}/include
	rm -f ${D}/${GAMES_BINDIR}/pinball-config
	prepgamesdirs
}
