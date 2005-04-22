# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/http-fetcher/http-fetcher-1.0.3.ebuild,v 1.7 2005/04/22 09:29:03 blubb Exp $

MY_P="${P/-/_}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="HTTP Fetcher is a small, robust, flexible library for downloading files via HTTP using the GET method."
HOMEPAGE="http://http-fetcher.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

RESTRICT="nomirror"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64 alpha ~ppc"
IUSE=""

RDEPEND="virtual/libc"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dohtml -r docs/index.html docs/html
	dodoc README ChangeLog CREDITS INSTALL LICENSE
}
