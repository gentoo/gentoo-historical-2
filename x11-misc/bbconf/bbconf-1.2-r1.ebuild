# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Grant Goodyear <g2boojum@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbconf/bbconf-1.2-r1.ebuild,v 1.3 2002/07/08 21:31:05 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="All-in-one blackbox configuration tool."
SRC_URI="http://${PN}.sourceforge.net/code/${P}.tar.gz"
HOMEPAGE="http://bbconf.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

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
