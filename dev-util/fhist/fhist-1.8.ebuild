# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fhist/fhist-1.8.ebuild,v 1.11 2004/06/25 02:31:41 agriffis Exp $

DESCRIPTION="File history and comparison tools"
SRC_URI="http://www.canb.auug.org.au/~millerp/${P}.tar.gz"
HOMEPAGE="http://www.canb.auug.org.au/~millerp/fhist.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

DEPEND="sys-devel/gettext
	sys-apps/groff
	sys-devel/bison"

src_compile() {
	econf || die "./configure failed"
	make clean
	make || die
}

src_install () {
	make RPM_BUILD_ROOT=${D} install || die

	dodoc lib/en/*.txt
	dodoc lib/en/*.ps

	# remove duplicate docs etc.
	rm -r ${D}/usr/share/fhist

	# move message catalogs into the usual gentoo place
	dodir /usr/share/locale
	mv ${D}/usr/lib/fhist/en ${D}/usr/share/locale/

	dodoc LICENSE MANIFEST README
}
