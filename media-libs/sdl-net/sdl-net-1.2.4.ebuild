# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-net/sdl-net-1.2.4.ebuild,v 1.9 2003/02/13 12:55:01 vapier Exp $

MY_P=${P/sdl-/SDL_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simple Direct Media Layer Network Support Library"
SRC_URI="http://www.libsdl.org/projects/SDL_net/release/${MY_P}.tar.gz"
HOMEPAGE="http://www.libsdl.org/projects/SDL_net/index.html"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 ppc sparc alpha"

DEPEND=">=media-libs/libsdl-1.2.4"

src_install() {
	einstall || die
	preplib /usr
	dodoc CHANGES COPYING README	
}
