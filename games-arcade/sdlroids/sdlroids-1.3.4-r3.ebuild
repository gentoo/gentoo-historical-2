# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/sdlroids/sdlroids-1.3.4-r3.ebuild,v 1.4 2004/06/24 22:11:29 agriffis Exp $

inherit games

DESCRIPTION="Asteroids Clone for X using SDL"
HOMEPAGE="http://david.hedbor.org/projects/sdlroids/"
SRC_URI="mirror://sourceforge/sdlroids/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64"
IUSE=""

RDEPEND=">=media-libs/libsdl-1.1.8"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}

	sed -i \
		-e 's/$(SOUNDSDIR)/$(DESTDIR)$(SOUNDSDIR)/' \
		-e 's/$(GFXDIR)/$(DESTDIR)$(GFXDIR)/' ${S}/Makefile.in \
		|| die "sed Makefile.in failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog README.* TODO
	prepgamesdirs
}
