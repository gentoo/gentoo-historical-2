# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ifstat/ifstat-1.1.ebuild,v 1.2 2004/06/24 22:04:14 agriffis Exp $

IUSE="snmp"

DESCRIPTION="Network interface bandwidth usage, with support for snmp targets."
SRC_URI="http://gael.roualland.free.fr/ifstat/${P}.tar.gz"
HOMEPAGE="http://gael.roualland.free.fr/ifstat/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~sparc"

DEPEND="virtual/glibc
	snmp? ( >=net-analyzer/net-snmp-5.0 )"

src_compile() {
	econf || die
	make || die
}

src_install () {
	einstall || die
	dodoc COPYING HISTORY INSTALL README TODO VERSION
}
