# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/corkscrew/corkscrew-2.0.ebuild,v 1.1.1.1 2005/11/30 09:55:38 chriswhite Exp $

DESCRIPTION="Corkscrew is a tool for tunneling SSH through HTTP proxies."
HOMEPAGE="http://www.agroman.net/corkscrew/"
LICENSE="GPL-2"
DEPEND=""
KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""
SLOT="0"
SRC_URI="http://www.agroman.net/corkscrew/${P}.tar.gz"

src_compile() {
	econf
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
}
