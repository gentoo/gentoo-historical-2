# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# /home/cvsroot/gentoo-x86/net-print/xpp/xpp-0.7.ebuild,v 1.3 2001/06/03 09:54:22 achim Exp
# $Header: /var/cvsroot/gentoo-x86/net-print/xpp/xpp-1.0.ebuild,v 1.2 2001/08/30 17:31:36 pm Exp $


S=${WORKDIR}/${P}
DESCRIPTION="X Printing Panel"
SRC_URI="ftp://cups.sourceforge.net/pub/cups/xpp/${P}.tar.gz"
HOMEPAGE="http://cups.sourceforge.net/xpp/"

DEPEND="virtual/glibc >=net-print/cups-1.1.7
	 >=x11-libs/fltk-1.0.10"

src_compile() {

    try ./configure --prefix=/usr/X11R6 --host=${CHOST}
    try make

}

src_install () {

    try make DESTDIR=${D} install
    dodoc LICENSE ChangeLog README
}

