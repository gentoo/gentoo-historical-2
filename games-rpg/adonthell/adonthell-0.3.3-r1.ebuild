# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/adonthell/adonthell-0.3.3-r1.ebuild,v 1.4 2004/02/29 21:07:54 vapier Exp $

inherit games

DESCRIPTION="roleplaying game engine"
HOMEPAGE="http://adonthell.linuxgames.com/"
SRC_URI="http://savannah.nongnu.org/download/adonthell/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE="oggvorbis gtk nls doc"

DEPEND="dev-lang/python
	media-libs/libsdl
	oggvorbis? ( media-libs/libvorbis
		media-libs/libogg )
	sys-libs/zlib
	gtk? ( =x11-libs/gtk+-1* )
	doc? ( app-doc/doxygen )"

src_compile() {
	egamesconf \
		`use_enable nls` \
		`use_enable doc` \
		--with-gnu-ld \
		|| die
	touch doc/items/{footer,header}.html
	emake || die
}

src_install() {
	emake install DESTDIR=${D} || die
	dodoc README AUTHORS ChangeLog FULLSCREEN.howto NEWBIE NEWS
	prepgamesdirs
}
