# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-apps/cervisia/cervisia-0.7.1.ebuild,v 1.1 2000/09/18 18:57:24 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A CVS Client for KDE"
SRC_URI="http://download.sourceforge.net/cervisia/${A}"
HOMEPAGE="http://cervisia.sourceforge.net"


src_compile() {

    cd ${S}
    try ./configure --prefix=/opt/kde --host=${CHOST} \
		--with-qt-dir=/usr/lib/qt-x11-2.2.0 \
		--with-qt-includes=/usr/lib/qt-x11-2.2.0/include \
		--with-qt-libs=/usr/lib/qt-x11-2.2.0/lib \
		--with-kde-version=2
    try make

}

src_install () {

    cd ${S}
    try make prefix=${D}/opt/kde install

}


