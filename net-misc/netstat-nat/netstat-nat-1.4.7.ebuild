# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/netstat-nat/netstat-nat-1.4.7.ebuild,v 1.6 2008/01/30 10:15:18 pva Exp $

DESCRIPTION="Display NAT connections"
HOMEPAGE="http://tweegy.demon.nl/projects/netstat-nat/index.html"
SRC_URI="http://tweegy.demon.nl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="virtual/libc"

src_install() {
	make DESTDIR="${D}" install || die
}
