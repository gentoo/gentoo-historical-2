# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/ViewKlass/ViewKlass-0.6.0.ebuild,v 1.4 2004/01/11 13:51:46 lanius Exp $

IUSE=""

DESCRIPTION="An implementation of the ViewKit user interface library"
SRC_URI="http://unc.dl.sourceforge.net/sourceforge/viewklass/${P}.tar.gz"
HOMEPAGE="http://viewklass.sourceforge.net"
LICENSE="LGPL-2.1"

DEPEND="x11-libs/openmotif"

SLOT="0"
KEYWORDS="~x86 ~sparc"

S=${WORKDIR}/${P}

src_compile() {
	zcat ${FILESDIR}/${P}-gentoo.patch| patch -p1 || die
	./configure --prefix=/usr || die "./configure failed"
	make CXXFLAGS="${CXXFLAGS} -I. -I/usr/X11R6/include" \
		CFLAGS="${CXXFLAGS} -I. -I/usr/X11R6/include" || die
}

src_install () {
	dodir /usr/lib
	make prefix=${D}/usr install || die
	dodoc INSTALL COPYING
}
