# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ttf2pt1/ttf2pt1-3.3.3.ebuild,v 1.11 2002/12/09 04:17:45 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Converts True Type to Type 1 fonts"
SRC_URI="mirror://sourceforge/ttf2pt1/${P}.tgz"
HOMEPAGE="http://ttf2pt1.sourceforge.net"
KEYWORDS="x86 sparc "
SLOT="0"
LICENSE="as-is"

RDEPEND="virtual/glibc
	>=media-libs/freetype-2.0"
DEPEND="$RDEPEND sys-devel/perl"

src_unpack() {
	unpack ${A}
	patch -p0 < ${FILESDIR}/${P}-Makefile-gentoo.diff
}

src_compile() {

	make CFLAGS="${CFLAGS}" all || die

}

src_install () {

	make INSTDIR=${D}/usr install || die
	dodir /usr/share/doc/${PF}/html
	cd ${D}/usr/share/ttf2pt1
	rm -r app other
	mv *.html ../doc/${PF}/html
	mv [A-Z]* ../doc/${PF}
	prepalldocs 
}
