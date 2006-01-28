# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/emilia-pinball/emilia-pinball-0.3.1.ebuild,v 1.10 2006/01/28 06:50:46 joshuabaergen Exp $

inherit games

MY_PN=${PN/emilia-/}
MY_P=${MY_PN}-${PV}
DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="http://pinball.sourceforge.net/"
SRC_URI="mirror://sourceforge/pinball/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha ~amd64 ppc ~sparc"
IUSE=""

RDEPEND="virtual/opengl
	|| ( x11-libs/libSM virtual/x11 )
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	|| ( x11-libs/libXt virtual/x11 )"

S=${WORKDIR}/${MY_P}

src_compile() {
	egamesconf \
		--with-x \
		|| die
	emake -j1 CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	dodoc README || die "dodoc failed"
	make DESTDIR=${D} install || die "make install failed"
	dosym ${GAMES_BINDIR}/pinball ${GAMES_BINDIR}/emilia-pinball
	mv "${D}/${GAMES_PREFIX}/include" "${D}/usr/" \
		|| die "mv failed (include)"
	dodir /usr/bin
	mv "${D}/${GAMES_BINDIR}/pinball-config" "${D}/usr/bin/" \
		|| die "mv failed (bin)"
	dosed 's:-I${prefix}/include/pinball:-I/usr/include/pinball:' /usr/bin/pinball-config
	prepgamesdirs
}
