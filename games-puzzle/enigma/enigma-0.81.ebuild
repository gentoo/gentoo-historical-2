# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/enigma/enigma-0.81.ebuild,v 1.12 2004/07/01 05:24:56 mr_bones_ Exp $

inherit games

DESCRIPTION="puzzle game similar to Oxyd"
HOMEPAGE="http://www.freesoftware.fsf.org/enigma/"
SRC_URI="http://savannah.nongnu.org/download/enigma/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64 ~sparc"
IUSE=""

RDEPEND="virtual/libc
	sys-libs/zlib
	media-libs/sdl-ttf
	>=media-libs/libsdl-1.2.0
	>=media-libs/sdl-mixer-1.2.4
	>=media-libs/sdl-image-1.2.0
	>=dev-lang/lua-4.0"
DEPEND="${RDEOEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e 's:$(pkgdatadir):$(DESTDIR)$(pkgdatadir):' \
		data/levels/Makefile.am \
		data/levels/Sokoban/Makefile.am \
		|| die "sed data/levels/{Sokoban/}?Makefile.am failed"
	aclocal || die "aclocal failed"
	automake || die "automake failed"
	autoconf || die "autoconf failed"
}

src_compile() {
	egamesconf --enable-optimize || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	mv ${D}/${GAMES_PREFIX}/share/* ${D}/usr/share/
	rm -r ${D}/${GAMES_PREFIX}/share
	dodoc NEWS README AUTHORS INSTALL ChangeLog
	prepgamesdirs
}
