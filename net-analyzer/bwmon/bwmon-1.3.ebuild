# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bwmon/bwmon-1.3.ebuild,v 1.6 2002/12/09 04:33:08 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Simple ncurses bandwidth monitor"
HOMEPAGE="http://bwmon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

DEPEND="sys-libs/ncurses"

SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="x86 sparc "

src_unpack() {

	unpack ${A}
	cd ${S}
	sed -e "s:/usr/local/bin:\$\{DESTDIR\}usr/bin:" \
	    Makefile > Makefile.hacked
	mv Makefile.hacked Makefile
	sed -e "s:CFLAGS =:CFLAGS = ${CFLAGS}:" \
	    -e "s:LDFLAGS =:LDFLAGS = -L/lib:" \
	    src/Makefile > src/Makefile.hacked
	mv src/Makefile.hacked src/Makefile
	
}


src_compile() {

	emake || die

}

src_install () {

	dodir /usr/bin
	make DESTDIR=${D} install || die
	dodoc README
}
