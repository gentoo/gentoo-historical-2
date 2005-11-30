# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/txt2pdbdoc/txt2pdbdoc-1.4.4.ebuild,v 1.1 2004/07/02 22:53:49 g2boojum Exp $

DESCRIPTION="Text to Doc file converter for the Palm Pilot.  Also includes an HTML to Doc converter."
SRC_URI="http://homepage.mac.com/pauljlucas/software/${P}.tar.gz"
HOMEPAGE="http://homepage.mac.com/pauljlucas/software.html"
KEYWORDS="x86 sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="dev-lang/perl"
IUSE=""

# automake error: INSTALL and NEWS files missing, and make breaks w/o them
src_unpack() {
	unpack ${A}
	cd ${S}
	touch INSTALL NEWS
}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING README INSTALL ChangeLog
}
