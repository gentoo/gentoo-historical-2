# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/fetch/fetch-1.0.ebuild,v 1.1 2005/03/17 18:21:18 seemant Exp $

DESCRIPTION="Fetch is a simple, fast, and flexible HTTP download tool built on the HTTP Fetcher library."
HOMEPAGE="http://cs.nmu.edu/~lhanson/fetch/"
SRC_URI="http://cs.nmu.edu/~lhanson/fetch/dls/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=dev-libs/http-fetcher-1.0.1"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README INSTALL LICENSE
	dohtml docs/*.html
}
