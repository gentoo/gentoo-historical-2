# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpick/tcpick-0.1.19.ebuild,v 1.2 2004/06/24 22:20:27 agriffis Exp $

DESCRIPTION="TCP Stream Sniffer and Connection Tracker"
HOMEPAGE="http://tcpick.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND="virtual/glibc
	>=net-libs/libpcap-0.7.2"

src_install() {
	make install DESTDIR=${D} || die "install failed"

	dodoc AUTHORS COPYING ChangeLog INSTALL INTERNALS KNOWN-BUGS \
		NEWS OPTIONS PLATFORMS README THANKS TODO
}
