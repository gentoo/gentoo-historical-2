# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/xgraph/xgraph-12.1.ebuild,v 1.3 2004/06/24 22:52:15 agriffis Exp $

DESCRIPTION="X11 Plotting Utility"
HOMEPAGE="http://www.isi.edu/nsnam/xgraph/"
SRC_URI="http://www.isi.edu/nsnam/dist/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 sparc"
IUSE=""
DEPEND="virtual/x11"

src_install() {
	make DESTDIR=${D} install || die
	dodoc README* INSTALL
	dodir /usr/share/${PN}/examples
	insinto /usr/share/${PN}/examples
	doins examples/*
	dodir /usr/share/man/man1
	mv ${D}/usr/share/man/manm/xgraph.man ${D}/usr/share/man/man1/xgraph.1
	ls ${D}/usr/share/man/manm/
	rm -Rf ${D}/usr/share/man/manm/
}

