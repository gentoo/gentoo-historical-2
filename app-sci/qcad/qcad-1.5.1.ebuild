# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/qcad/qcad-1.5.1.ebuild,v 1.4 2003/02/13 09:25:07 vapier Exp $
inherit kde-functions

MY_P=${P}-src
S=${WORKDIR}/${MY_P}
DESCRIPTION="A 2D CAD package based upon Qt."
SRC_URI="mirror://sourceforge/qcad//${MY_P}.tar.gz"
HOMEPAGE="http://www.qcad.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=x11-libs/qt-3"

set-qtdir 3

src_compile() {
	cd ${S}
    	emake CXXFLAGS="$CXXFLAGS" || die
}

src_install () {
	dobin qcad

	dohtml -r doc

	dodoc AUTHORS COPYING INSTALL MANIFEST README TODO changes-*
	docinto examples
	dodoc examples/*

	dodir /usr/share/${PN}
	cp -a fonts hatches libraries messages templates ${D}/usr/share/${PN}

	insinto /usr/share/${PN}/pixmaps
	doins xpm/*
}
