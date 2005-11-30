# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/global/global-4.5.ebuild,v 1.1 2002/10/26 16:34:58 jrray Exp $

DEPEND=">=sys-libs/glibc-2.2"
DESCRIPTION="Global can find the locations of specified object in C, C++, Yacc, Java and assembler source files."
HOMEPAGE="http://www.gnu.org"
LICENSE="GPL-2"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
S=${WORKDIR}/${P}
IUSE=""
KEYWORDS="~x86"
SLOT="0"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install() {
	einstall || die	
	dodoc AUTHORS COPYING INSTALL README NEWS
}
