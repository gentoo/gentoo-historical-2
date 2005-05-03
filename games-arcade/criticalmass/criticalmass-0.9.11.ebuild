# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/criticalmass/criticalmass-0.9.11.ebuild,v 1.2 2005/05/03 08:54:43 dholm Exp $

inherit eutils games

DESCRIPTION="SDL/OpenGL space shoot'em up game"
HOMEPAGE="http://criticalmass.sourceforge.net/"
SRC_URI="mirror://sourceforge/criticalmass/CriticalMass-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86 ~ppc"
IUSE=""

DEPEND="media-libs/sdl-mixer
	media-libs/sdl-image
	virtual/opengl"

S=${WORKDIR}/CriticalMass-${PV}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dohtml Readme.html
	dodoc TODO
	prepgamesdirs
}
