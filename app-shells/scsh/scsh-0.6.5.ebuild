# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/scsh/scsh-0.6.5.ebuild,v 1.2 2004/06/24 22:25:45 agriffis Exp $

DESCRIPTION="Unix shell embedded in Scheme"
SRC_URI="ftp://ftp.scsh.net/pub/scsh/0.6/${P}.tar.gz"
HOMEPAGE="http://www.scsh.net/"

SLOT="0"
LICENSE="as-is | BSD | GPL-2"
KEYWORDS="x86 ppc sparc"

DEPEND=""

src_compile() {
	econf --prefix=/usr	--libdir=/usr/lib --includedir=/usr/include || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc RELEASE COPYING
	# Let Scsh install the documentation and then clean up afterwards
	dosed "s:${D}::" /usr/share/man/man1/scsh.1
	dodir /usr/share/doc/${PF}
	mv ${D}/usr/lib/scsh/doc/* ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/lib/scsh/doc
}
