# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/SoQt/SoQt-20010601-r1.ebuild,v 1.9 2002/12/09 04:26:10 manson Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A Qt Interface for coin"
SRC_URI="ftp://ftp.coin3d.org/pub/snapshots/${A}"
HOMEPAGE="http://www.coinn3d.org"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 sparc "


DEPEND="virtual/x11 
	virtual/opengl 
	=x11-libs/qt-2.3*
	=media-libs/coin-${PV}*"

src_compile() {

	econf --qith-qt-dir=/usr/qt/2 || die
	make || die

}

src_install () {

	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING ChangeLog* LICENSE* NEWS README*
	docinto txt
	dodoc docs/qtcomponents.doxygen

}
