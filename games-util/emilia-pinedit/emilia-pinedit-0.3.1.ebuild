# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/emilia-pinedit/emilia-pinedit-0.3.1.ebuild,v 1.6 2004/05/11 12:56:39 vapier Exp $

inherit eutils games

MY_P=${PN/emilia-/}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A table-editor for the emilia-pinball"
HOMEPAGE="http://pinball.sourceforge.net/"
SRC_URI="mirror://sourceforge/pinball/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/x11
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	>=games-arcade/emilia-pinball-0.3.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "/^CFLAGS=/s:-g -W -Wall:${CFLAGS}:" \
		-e "/^CXXFLAGS=/s:-g -W -Wall:${CXXFLAGS}:" \
		configure \
		|| die "sed configure failed"
	sed -i \
		-e "/^LDFLAGS/s:$:`pinball-config --libs` @LIBS@ -lSDL -lSDL_image -lSDL_mixer:" \
		pinedit/Makefile.in \
		|| die "sed pinedit/Makefile.in failed"
	epatch ${FILESDIR}/${PV}-assert.patch
}

src_compile() {
	egamesconf || die
	emake -j1 || die
}

src_install() {
	dodoc AUTHORS INSTALL NEWS README
	make DESTDIR=${D} install || die "make install failed"
	rm -rf ${D}/${GAMES_PREFIX}/{include,lib}
	prepgamesdirs
}
