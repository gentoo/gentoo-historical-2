# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Claes N�sten <pekdon@gmx.net>
# $Header: /var/cvsroot/gentoo-x86/media-sound/oggtst/oggtst-0.0.ebuild,v 1.1 2001/11/02 22:59:10 azarah Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A tool for calculate ogg-vorbis playing time."
SRC_URI="http://gnometoaster.rulez.org/archive//${PN}.tgz"
HOMEPAGE="http://gnometoaster.rulez.org/"

DEPEND="virtual/glibc
	>=media-libs/libao-0.8.0
	>=media-libs/libogg-1.0_rc2
	>=media-libs/libvorbis-1.0_rc2"


src_compile() {

	./configure \
		--host=${CHOST}				\
		--prefix=/usr				\
		--infodir=/usr/share/info		\
		--mandir=/usr/share/man			\
		|| die
		
	make || die
}

src_install() {

	make DESTDIR=${D}				\
		install || die
	
	dodoc AUTHORS ChangeLog README
}
