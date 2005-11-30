# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/balance/balance-3.19.ebuild,v 1.1.1.1 2005/11/30 09:55:30 chriswhite Exp $

DESCRIPTION="TCP Load Balancing Port Forwarder"
HOMEPAGE="http://www.inlab.de/balance.html"
SRC_URI="http://www.inlab.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

src_compile() {
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	doman balance.1
	dosbin balance || die
	dodir /var/run/balance
	fperms 1777 /var/run/balance
}
