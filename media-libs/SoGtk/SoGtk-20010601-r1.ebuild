# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/SoGtk/SoGtk-20010601-r1.ebuild,v 1.6 2002/07/22 14:37:05 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="A Gtk Interface for coin"
SRC_URI="ftp://ftp.coin3d.org/pub/snapshots/${P}.tar.gz"
HOMEPAGE="http://www.coin3d.org"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86"

DEPEND="virtual/x11
	<x11-libs/gtkglarea-1.99.0
	media-libs/coin"

src_compile() {

	./bootstrap --add

	econf || die
	make || die
}

src_install () {
	
	make prefix=${D}/usr install || die
	
	cd ${S}
	dodoc AUTHORS COPYING ChangeLog* LICENSE* NEWS README*
	docinto txt
	dodoc docs/*
}
