# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/boswars/boswars-2.4.1.ebuild,v 1.2 2008/01/22 04:09:39 nyhm Exp $

inherit eutils games

DESCRIPTION="Futuristic real-time strategy game"
HOMEPAGE="http://www.boswars.org/"
SRC_URI="http://www.boswars.org/dist/releases/${P}-src.tar.gz
	mirror://gentoo/bos.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-lang/lua
	media-libs/libsdl
	media-libs/libpng
	media-libs/libvorbis
	media-libs/libtheora
	media-libs/libogg
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${P}-src

src_unpack() {
	unpack ${A/bos.png}
	cd "${S}"
	rm -f doc/{README-SDL.txt,guichan-copyright.txt}
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		engine/include/stratagus.h \
		|| die "sed failed"
}

src_compile() {
	scons || die "scons failed"
}

src_install() {
	dogamesbin ${PN} || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r campaigns graphics languages maps scripts sounds units video \
		|| die "doins failed"
	doicon "${DISTDIR}"/bos.png
	make_desktop_entry ${PN} "Bos Wars"	bos.png
	dodoc CHANGELOG COPYRIGHT.txt README.txt
	dohtml -r doc/*
	prepgamesdirs
}
