# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/ViewKlass/ViewKlass-0.7.0.ebuild,v 1.3 2004/06/24 22:08:22 agriffis Exp $

IUSE=""

DESCRIPTION="An implementation of the ViewKit user interface library"
SRC_URI="mirror://sourceforge/viewklass/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://viewklass.sourceforge.net"
LICENSE="LGPL-2.1"

DEPEND="x11-libs/openmotif"

SLOT="0"
KEYWORDS="~x86 ~sparc"

src_compile() {
	./configure --prefix=/usr || die "./configure failed"
	make CXXFLAGS="${CXXFLAGS} -I. -I/usr/X11R6/include" \
		CFLAGS="${CXXFLAGS} -I. -I/usr/X11R6/include" || die
}

src_install () {
	dodir /usr/lib
	make prefix=${D}/usr install || die
	dodoc INSTALL COPYING
}
