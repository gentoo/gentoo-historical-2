# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/braa/braa-0.8.ebuild,v 1.1.1.1 2005/11/30 10:12:34 chriswhite Exp $

DESCRIPTION="Quick and dirty mass SNMP scanner"

HOMEPAGE="http://s-tech.elsat.net.pl/braa/"
SRC_URI="http://s-tech.elsat.net.pl/braa/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64 ~sparc"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin braa

	dodoc COPYING README VERSION
}
