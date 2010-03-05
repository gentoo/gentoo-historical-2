# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/emilia-pinball/emilia-pinball-0.3.1-r1.ebuild,v 1.1 2010/03/05 18:41:15 ssuominen Exp $

EAPI=2
inherit autotools eutils games

MY_PN=${PN/emilia-/}
MY_P=${MY_PN}-${PV}
DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="http://pinball.sourceforge.net/"
SRC_URI="mirror://sourceforge/pinball/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="virtual/opengl
	x11-libs/libSM
	media-libs/libsdl[opengl,video,X]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	>=sys-devel/libtool-2.2.6b"
DEPEND="${RDEPEND}
	x11-libs/libXt"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc210.patch \
		"${FILESDIR}"/${P}-libtool.patch
	rm -rf libltdl
	eautoreconf
}

src_configure() {
	egamesconf --with-x
}

src_compile() {
	emake -j1 CXXFLAGS="${CXXFLAGS}" || die "emake failed"
}

src_install() {
	dodoc README || die "dodoc failed"
	emake DESTDIR="${D}" install || die "emake install failed"
	dosym "${GAMES_BINDIR}"/pinball "${GAMES_BINDIR}"/emilia-pinball
	mv "${D}/${GAMES_PREFIX}/include" "${D}/usr/" \
		|| die "mv failed (include)"
	dodir /usr/bin
	mv "${D}/${GAMES_BINDIR}/pinball-config" "${D}/usr/bin/" \
		|| die "mv failed (bin)"
	sed -i \
		-e 's:-I${prefix}/include/pinball:-I/usr/include/pinball:' \
		"${D}"/usr/bin/pinball-config || die "sed failed"
	newicon data/pinball.xpm ${PN}.xpm
	make_desktop_entry emilia-pinball "Emilia pinball"
	prepgamesdirs
}
