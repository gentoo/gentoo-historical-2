# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/mergelog/mergelog-4.5.ebuild,v 1.4 2004/07/01 22:44:52 eradicator Exp $

DESCRIPTION="A utility to merge apache logs in chronological order"
SRC_URI="mirror://sourceforge/mergelog/${P}.tar.gz"
HOMEPAGE="http://mergelog.sourceforge.net"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND="virtual/libc"
RDEPEND=""

src_compile() {
	econf || die "configure failed"
	emake  || die "make failed"
}

src_install() {
	einstall
	dobin src/mergelog src/zmergelog

	doman man/*.1
	dodoc AUTHORS COPYING README
}
