# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/ttmkfdir/ttmkfdir-2.0.ebuild,v 1.4 2003/02/13 17:18:24 vapier Exp $

S="${WORKDIR}/${PN}2"
DESCRIPTION="A utility to create a fonts.scale file from a set of TrueType fonts"
SRC_URI="mirror://gentoo/ttmkfdir2-1.0.tar.bz2"
HOMEPAGE="http://www.joerg-pommnitz.de/TrueType/xfsft.html"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 sparc  ppc alpha"

DEPEND=">=media-libs/freetype-2.0.8
	>=sys-devel/flex-2.5.4a-r5
	sys-devel/libtool"

src_unpack() {
	unpack ${A}

	cd ${S}; patch -p1 < ${FILESDIR}/${P}-gentoo.patch || die

	cp ${S}/Makefile ${S}/Makefile.orig
	sed -e "s:CXXFLAGS=-Wall:CXXFLAGS=${CFLAGS} -Wall:" \
		${S}/Makefile.orig > ${S}/Makefile
}

src_compile() {
	make OPT="${CFLAGS}" || die
}

src_install() {
	exeinto /usr/X11R6/bin
	doexe ${S}/ttmkfdir
}

