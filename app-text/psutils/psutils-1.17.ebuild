# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/psutils/psutils-1.17.ebuild,v 1.18 2004/06/28 02:08:00 ciaranm Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Post Script Utilities"
SRC_URI="ftp://ftp.enst.fr/pub/unix/a2ps/${P}.tar.gz"
HOMEPAGE="http://www.tardis.ed.ac.uk/~ajcd/psutils"
KEYWORDS="ia64 x86 ppc sparc alpha amd64 hppa mips"
SLOT="0"
LICENSE="as-is"

DEPEND="virtual/glibc dev-lang/perl"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	sed -e "s:/usr/local:\$(DESTDIR)/usr:" \
	-e "s:-DUNIX -O:-DUNIX ${CFLAGS}:" ${S}/Makefile.unix > ${S}/Makefile
}

src_compile() {

	make || die

}

src_install () {
	dodir /usr/{bin,share/man}
	make DESTDIR=${D} install || die
	dodoc README LICENSE
}
