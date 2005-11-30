# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/puf/puf-0.93.2a.ebuild,v 1.1.1.1 2005/11/30 09:54:52 chriswhite Exp $

DESCRIPTION="A download tool for UNIX-like systems."
SRC_URI="mirror://sourceforge/puf/${P}.tar.gz"
HOMEPAGE="http://puf.sourceforge.net/"

DEPEND="virtual/libc"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

src_compile() {
	econf || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS NEWS README TODO
}
