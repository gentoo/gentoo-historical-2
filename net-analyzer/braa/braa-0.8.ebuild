# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/braa/braa-0.8.ebuild,v 1.1 2004/06/08 15:45:28 squinky86 Exp $

DESCRIPTION="Quick and dirty mass SNMP scanner"

HOMEPAGE="http://s-tech.elsat.net.pl/braa/"
SRC_URI="http://s-tech.elsat.net.pl/braa/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/glibc"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin braa

	dodoc COPYING README VERSION
}
