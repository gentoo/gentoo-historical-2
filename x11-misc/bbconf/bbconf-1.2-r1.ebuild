# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbconf/bbconf-1.2-r1.ebuild,v 1.13 2004/04/14 09:09:01 aliz Exp $

DESCRIPTION="All-in-one blackbox configuration tool."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://bbconf.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc "
IUSE=""

DEPEND="virtual/x11
	=x11-libs/qt-2*"

#RDEPEND=""

src_compile () {
	./configure --prefix=/usr --host=${CHOST} --with-qt-dir=/usr/qt/2 || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
