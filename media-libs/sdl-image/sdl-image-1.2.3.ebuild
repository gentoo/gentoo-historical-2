# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-image/sdl-image-1.2.3.ebuild,v 1.3 2003/10/06 18:50:41 agriffis Exp $

MY_P="${P/sdl-/SDL_}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="image file loading library"
SRC_URI="http://www.libsdl.org/projects/SDL_image/release/${MY_P}.tar.gz"
HOMEPAGE="http://www.libsdl.org/projects/SDL_image/index.html"

KEYWORDS="x86 ~ppc ~sparc ~amd64 alpha"
LICENSE="LGPL-2"
SLOT="0"

DEPEND=">=media-libs/libpng-1.2.1
	>=media-libs/jpeg-6b
	>=media-libs/libsdl-1.2.4
	sys-libs/zlib"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc CHANGES README
}
