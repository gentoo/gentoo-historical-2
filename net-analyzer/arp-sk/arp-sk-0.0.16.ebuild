# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/arp-sk/arp-sk-0.0.16.ebuild,v 1.1 2005/01/22 00:28:43 ka0ttic Exp $

DESCRIPTION="A swiss knife tool for ARP"
HOMEPAGE="http://www.arp-sk.org/"
SRC_URI="http://www.arp-sk.org/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""
DEPEND=">=net-libs/libnet-1.1"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# We don't need libcompat as it has a potential to clash with other packages.
	rm -fr ${D}/usr/lib

	dodoc ARP AUTHORS CONTRIB ChangeLog INSTALL README TODO
}

src_compile() {
	econf || die
	emake || die
}
