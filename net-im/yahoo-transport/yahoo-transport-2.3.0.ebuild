# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/yahoo-transport/yahoo-transport-2.3.0.ebuild,v 1.3 2004/04/27 22:03:21 agriffis Exp $

inherit eutils

DESCRIPTION="Open Source Jabber Server Yahoo transport"
HOMEPAGE="http://yahoo-transport-2.jabberstudio.org/"
SRC_URI="http://www.jabberstudio.org/files/yahoo-transport-2/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"

DEPEND=">=net-im/jabberd-1.4.3"

src_unpack() {
		unpack ${A}
		cd ${S}
		epatch ${FILESDIR}/yahoo-makefile.patch
}

src_compile() {
		  emake || die
}

src_install() {
		 dodir /etc/jabber /usr/lib/jabberd
		 insinto /usr/lib/jabberd
		 doins yahoo-transport.so
		 insinto /etc/jabber
		 doins  ${FILESDIR}/yahootrans.xml
		 dodoc README ${FILESDIR}/README.Gentoo
}

pkg_postinst() {
	einfo
	einfo "Please read /usr/share/doc/${P}/README.Gentoo.gz"
	einfo
}
