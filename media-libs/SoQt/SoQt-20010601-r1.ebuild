# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/media-libs/SoQt/SoQt-20010601-r1.ebuild,v 1.1 2001/10/06 15:30:16 danarmak Exp $


A=${P}.tar.gz
S=${WORKDIR}/${PN}
DESCRIPTION="A Qt Interface for coin"
SRC_URI="ftp://ftp.coin3d.org/pub/snapshots/${A}"
HOMEPAGE="http://www.coinn3d.org"

DEPEND="virtual/x11
        virtual/opengl
	>=x11-libs/qt-x11-2.3
        =media-libs/coin-${PV}"

src_compile() {

    try ./configure --prefix=/usr --host=${CHOST} --build=${CHOST}
    try make

}

src_install () {

    try make DESTDIR=${D} install
    dodoc AUTHORS COPYING ChangeLog* LICENSE* NEWS README*
    docinto txt
    dodoc docs/qtcomponents.doxygen

}

