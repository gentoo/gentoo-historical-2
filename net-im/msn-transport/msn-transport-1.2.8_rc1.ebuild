# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/msn-transport/msn-transport-1.2.8_rc1.ebuild,v 1.7 2004/05/24 00:42:33 humpback Exp $

MY_PV="${PV/_rc/rc}"
S="${WORKDIR}/${PN}-${MY_PV}"
DESCRIPTION="MSN transport for jabberd"
HOMEPAGE="http://msn-transport.jabberstudio.org/"
SRC_URI="http://msn-transport.jabberstudio.org/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc"

DEPEND=">=net-im/jabberd-1.4.3
	net-misc/curl"

src_compile() {
	econf \
		--with-jabberd=/usr/include/jabberd \
		--with-pth=/usr/include \
		|| die
	emake || die
}

src_install() {
	dodir /etc/jabber /usr/lib/jabberd
	insinto /usr/lib/jabberd
	doins src/msntrans.so || die
	insinto /etc/jabber
	doins ${FILESDIR}/msnt.xml
	dodoc README ${FILESDIR}/README.Gentoo msnt.xml
}

pkg_postinst() {
	einfo "Please read /usr/share/doc/${PF}/README.Gentoo.gz"
}
