# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/msn-transport/msn-transport-1.2.8_rc1.ebuild,v 1.3 2004/01/23 19:22:19 humpback Exp $

MY_PV="${PV/_rc/rc}"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="Open Source Jabber Server MSN transport"
HOMEPAGE="http://msn-transport.jabberstudio.org/"
SRC_URI="http://msn-transport.jabberstudio.org/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""
SLOT="0"

DEPEND=">=net-im/jabberd-1.4.3
		net-ftp/curl"

src_compile() {
		./configure --with-jabberd=/usr/include/jabberd --with-pth=/usr/include || die
		emake || die
}

src_install() {
		dodir /etc/jabber /usr/lib/jabberd
		insinto /usr/lib/jabberd
		doins src/msntrans.so
		insinto /etc/jabber
		doins  ${FILESDIR}/msnt.xml
		dodoc README ${FILESDIR}/README.Gentoo msnt.xml
}

pkg_postinst() {
	einfo
	einfo "Please read /usr/share/doc/${P}/README.Gentoo.gz"
	einfo
}
