# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-net/sdl-net-1.2.5.ebuild,v 1.3 2003/11/29 21:58:41 brad_mssw Exp $

MY_P=${P/sdl-/SDL_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Simple Direct Media Layer Network Support Library"
SRC_URI="http://www.libsdl.org/projects/SDL_net/release/${MY_P}.tar.gz"
HOMEPAGE="http://www.libsdl.org/projects/SDL_net/index.html"

KEYWORDS="x86 ~ppc ~sparc ~alpha amd64"
LICENSE="LGPL-2"
SLOT="0"

DEPEND=">=media-libs/libsdl-1.2.5"

src_install() {
	einstall || die
	preplib /usr
	dodoc CHANGES README
}
