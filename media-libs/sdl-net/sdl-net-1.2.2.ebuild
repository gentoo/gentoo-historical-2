# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-net/sdl-net-1.2.2.ebuild,v 1.2 2002/07/11 06:30:39 drobbins Exp $

A=SDL_net-${PV}.tar.gz
S=${WORKDIR}/SDL_net-${PV}
DESCRIPTION="Simple Direct Media Layer Network Support Library"
SRC_URI="http://www.libsdl.org/projects/SDL_net/release/${A}"
HOMEPAGE="http://www.libsdl.org/projects/SDL_net/index.html"

DEPEND="virtual/glibc
	>=media-libs/libsdl-1.2.0"

src_compile() {
  try ./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man
  try make
}

src_install() {
  cd ${S}
  try make DESTDIR=${D} install
  preplib /usr
  dodoc CHANGES COPYING README  
}
