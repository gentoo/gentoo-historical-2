# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/gngb/gngb-20020111.ebuild,v 1.2 2002/06/18 23:28:01 rphillips Exp $

DESCRIPTION="gngb - Gameboy / Gameboy Color emulator"
HOMEPAGE="http://members.lycos.fr/frogus/gngb/"
LICENSE="GPL"
RDEPEND="media-libs/libsdl
        opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}"
SRC_URI="http://membres.lycos.fr/frogus/gngb/download/${P}.tar.gz"
S=${WORKDIR}/${P}

src_compile() {
	use opengl || myconf=" --with-gl "
	./configure ${myconf}\
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	
	emake || die
}

src_install () {
	dodoc NEWS README TODO INSTALL AUTHORS
	make DESTDIR=${D} install || die
}
