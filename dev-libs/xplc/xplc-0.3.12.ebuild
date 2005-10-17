# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xplc/xplc-0.3.12.ebuild,v 1.4 2005/10/17 16:09:26 gustavoz Exp $

DESCRIPTION="cross platform lightweight components library for C++"
HOMEPAGE="http://xplc.sourceforge.net"
SRC_URI="mirror://sourceforge/xplc/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~ppc sparc x86"
IUSE=""

DEPEND="virtual/libc
	dev-util/pkgconfig"

src_test() {
	make tests || die "at least one test has failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dosym /usr/lib/pkgconfig/${P}.pc /usr/lib/pkgconfig/${PN}.pc
	dodoc LICENSE README NEWS CREDITS
}
