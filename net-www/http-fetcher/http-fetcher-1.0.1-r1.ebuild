# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/http-fetcher/http-fetcher-1.0.1-r1.ebuild,v 1.1 2003/01/07 07:12:15 mkennedy Exp $

DESCRIPTION="HTTP Fetcher is a small, robust, flexible library for downloading files via HTTP using the GET method."
HOMEPAGE="http://cs.nmu.edu/~lhanson/http_fetcher/"
SRC_URI="http://cs.nmu.edu/~lhanson/http_fetcher/dls/${P/-/_}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/glibc"

S=${WORKDIR}/${P/-/_}

src_unpack () {
	unpack ${A}
	# source: InetCop Security Advisory, Bugtraq, 06 Jan 2003
	cd ${S}/src && patch -p0 <${FILESDIR}/buffer-overflow-gentoo.patch || die
}

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

