# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/http-fetcher/http-fetcher-1.0.1.ebuild,v 1.4 2004/07/02 04:42:46 eradicator Exp $

DESCRIPTION="HTTP Fetcher is a small, robust, flexible library for downloading files via HTTP using the GET method."
HOMEPAGE="http://cs.nmu.edu/~lhanson/http_fetcher/"
SRC_URI="http://cs.nmu.edu/~lhanson/http_fetcher/dls/${P/-/_}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${P/-/_}

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
	dohtml -r docs/index.html docs/html
	dodoc README ChangeLog INSTALL LICENSE
}
