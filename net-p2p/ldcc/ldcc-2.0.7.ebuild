# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/ldcc/ldcc-2.0.7.ebuild,v 1.9 2005/07/10 20:02:06 swegener Exp $

IUSE=""

DESCRIPTION="linux console, text-based client for DIRECT CONNECT"
HOMEPAGE="http://www.softservice.com.pl/ldcc/"
SRC_URI="http://main.loop.com.pl/~softservice/ldcc/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"

DEPEND="net-p2p/dctc
	dev-libs/tvision"

src_compile() {
	econf \
		--with-tv-include=/usr/include/rhtvision \
		|| die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dodoc AUTHORS ChangeLog NEWS README
}
