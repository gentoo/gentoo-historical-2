# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dgen-sdl/dgen-sdl-1.23.ebuild,v 1.2 2002/08/02 08:21:08 rphillips Exp $

S=${WORKDIR}/${P}
DESCRIPTION="DGen/SDL is a Linux/SDL-Port of the famous DGen MegaDrive/Genesis-Emulator"
HOMEPAGE="http://www.pknet.com/~joe/dgen-sdl.html"
LICENSE="dgen-sdl"
SRC_URI="http://www.pknet.com/~joe/${P}.tar.gz"
SLOT="0"
KEYWORDS="x86"

DEPEND="media-libs/libsdl
		X? (virtual/X11)
		opengl? (virtual/opengl)"
RDEPEND="${DEPEND}
		dev-lang/nasm"

src_compile() {
	local myconf=""
	
	use opengl || myconf="${myconf} --without-opengl"
	use X && myconf="${myconf} --with-x"
	use mmx || myconf="${myconf} --without-mmx"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myconf} || die
	
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
