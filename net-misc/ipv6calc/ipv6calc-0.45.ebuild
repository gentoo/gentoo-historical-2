# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ipv6calc/ipv6calc-0.45.ebuild,v 1.11 2005/07/30 18:04:37 swegener Exp $

IUSE=""
DESCRIPTION="ipv6calc convert a given IPv6 address to the compressed format or to the format used by /proc/net/if_inet6."
HOMEPAGE="http://www.deepspace6.net/projects/ipv6calc.html"
KEYWORDS="x86 ppc"
SRC_URI="ftp://ftp.deepspace6.net/pub/sources/ipv6calc/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/libc"

src_install () {
	# Using installonly to skip the tests scripts which are really broken
	make root=${D} installonly || die
	dodoc ChangeLog README TODO CREDITS LICENSE
}
