# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/scsh/scsh-0.6.3.ebuild,v 1.5 2005/01/01 16:00:16 eradicator Exp $

DESCRIPTION="Unix shell embedded in Scheme"
HOMEPAGE="http://www.scsh.net/"
SRC_URI="ftp://ftp.scsh.net/pub/scsh/0.6/${P}.tar.gz"

LICENSE="|| ( as-is BSD GPL-2 )"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE=""

DEPEND=""

src_compile() {
	econf --prefix=/usr --libdir=/usr/lib --includedir=/usr/include || die
	make || die
}

src_install() {
	einstall prefix=${D}/usr \
		htmldir=${D}/usr/share/doc/${PF}/html \
		incdir=${D}/usr/include \
		mandir=${D}/usr/share/man/man1 \
		libdir=${D}/usr/lib || die
	dodoc RELEASE

	# Let scsh install the documentation and then clean up afterwards

	dosed "s:${D}::" /usr/share/man/man1/scsh.1
	dodir /usr/share/doc/${PF}
	find /usr/share/doc/
	mv ${D}/usr/lib/scsh/doc/* ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/lib/scsh/doc
}
