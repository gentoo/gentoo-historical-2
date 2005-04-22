# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/airsnort/airsnort-0.2.7e.ebuild,v 1.1 2005/04/22 17:51:15 genstef Exp $

DESCRIPTION="802.11b Wireless Packet Sniffer/WEP Cracker"
HOMEPAGE="http://airsnort.shmoo.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=x11-libs/gtk+-2*
	virtual/libpcap"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README README.decrypt AUTHORS ChangeLog TODO faq.txt
}

pkg_postinst() {
	einfo "Make sure to emerge linux-wlan-ng if you want support"
	einfo "for Prism2 based cards in airsnort."

	einfo "Make sure to emerge orinoco if you want support"
	einfo "for Orinoco based cards in airsnort."
}
