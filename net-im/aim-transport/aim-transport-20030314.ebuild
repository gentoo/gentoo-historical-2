# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/aim-transport/aim-transport-20030314.ebuild,v 1.2 2004/02/17 21:39:02 humpback Exp $

MY_PN="${PN}-stable"
S="${WORKDIR}/${MY_PN}-${PV}"
DESCRIPTION="AOL Instant Messaging transport for jabberd"

HOMEPAGE="http://aim-transport.jabberstudio.org/"

SRC_URI="http://aim-transport.jabberstudio.org/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86"

IUSE=""

DEPEND=">=net-im/jabberd-1.4.3"



src_compile() {
	einfo
	einfo "Please ignore any errors"
	einfo
	./configure --with-jabberd=/usr/include/jabberd || die "./configure failed"
	emake || die
}

src_install() {
	dodir /etc/jabber /usr/lib/jabberd
	insinto /usr/lib/jabberd
	doins src/aimtrans.so
	insinto /etc/jabber
	doins ${FILESDIR}/aimtrans.xml
	dodoc README ${FILESDIR}/README.Gentoo TODO aim.xml
}

pkg_postinst() {
	einfo
	einfo "Please read /usr/share/doc/${P}/README.Gentoo.gz"
	einfo
}

