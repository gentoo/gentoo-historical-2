# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Claes N�st�n <pekdon@gmx.net>
# /home/cvsroot/gentoo-x86/skel.build,v 1.7 2001/08/25 21:15:08 chadh Exp

S=${WORKDIR}/${P}
DESCRIPTION="Giblib, graphics library"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"
HOMEPAGE="http://www.libuxbrit.co.uk/"

DEPEND="virtual/glibc
	>=media-libs/imlib2-1.0.3
	>=media-libs/freetype-2.0"

src_compile() {
	./configure --infodir=/usr/share/info --mandir=/usr/share/man --prefix=/usr --host=${CHOST} || die
	emake || die
}

src_install () {	
	make prefix=${D}/usr install || die
	rm -rf ${D}/usr/doc
	dodoc TODO README AUTHORS ChangeLog
}

