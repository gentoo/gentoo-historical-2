# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdlmm/sdlmm-0.1.8-r1.ebuild,v 1.11 2004/07/14 20:27:12 agriffis Exp $

MY_P="${P/sdl/SDL}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="A C++ Wrapper for the Simple DirectMedia Layer"
HOMEPAGE="http://sdlmm.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlmm/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.4"

src_compile() {
	econf || die
	emake LDFLAGS="-lstdc++" || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING README THANKS
}
