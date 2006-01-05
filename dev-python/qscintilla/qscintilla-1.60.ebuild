# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/qscintilla/qscintilla-1.60.ebuild,v 1.14 2006/01/05 20:32:13 gustavoz Exp $

inherit eutils

MY_P=${P}-gpl-1.3
S=${WORKDIR}/${MY_P}

DESCRIPTION="QScintilla is a port to Qt of Neil Hodgson's Scintilla C++ editor class."
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
HOMEPAGE="http://www.riverbankcomputing.co.uk/qscintilla/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~ia64 ppc ~sparc ~x86"
IUSE="doc"

DEPEND="virtual/libc
	=x11-libs/qt-3*"

src_compile() {
	cd ${S}/qt
	${QTDIR}/bin/qmake -o Makefile qscintilla.pro
	sed -i -e "s/CFLAGS   = -pipe -w -O2/CFLAGS   = ${CFLAGS} -w/" Makefile
	sed -i -e "s/CXXFLAGS = -pipe -w -O2/CXXFLAGS = ${CXXFLAGS} -w/" Makefile
	epatch ${FILESDIR}/${P}-sandbox.patch
	make all staticlib
}

src_install() {
	dodoc ChangeLog LICENSE NEWS README
	dodir ${QTDIR}/{include,translations,lib}
	cd ${S}/qt
	cp qextscintilla*.h ${D}/$QTDIR/include
	cp qscintilla*.qm ${D}/$QTDIR/translations
	cp libqscintilla.a* ${D}/$QTDIR/lib
	cp -d libqscintilla.so.* ${D}/$QTDIR/lib
	use doc && ( dohtml ${S}/doc/html/*
		insinto /usr/share/doc/${PF}/Scintilla
		doins ${S}/doc/Scintilla/* )
}
