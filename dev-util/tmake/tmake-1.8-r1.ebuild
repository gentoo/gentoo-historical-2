# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/tmake/tmake-1.8-r1.ebuild,v 1.13 2004/06/25 02:48:55 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A Cross platform Makefile tool"
SRC_URI="ftp://ftp.trolltech.com/freebies/tmake/${P}.tar.gz"
HOMEPAGE="http://www.trolltech.com/products/download/freebies/tmake.html"

RDEPEND="dev-lang/perl"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc alpha ~ia64 s390 ~ppc"

src_install () {

	cd ${S}
	dobin bin/tmake bin/progen
	dodir /usr/lib/tmake
	cp -af ${S}/lib/* ${D}/usr/lib/tmake
	dodoc CHANGES LICENSE README
	dodoc html -r doc
	dodir /etc/env.d
	echo "TMAKEPATH=/usr/lib/tmake/linux-g++" > ${D}/etc/env.d/51tmake
}
