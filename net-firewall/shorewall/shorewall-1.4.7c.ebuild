# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/shorewall/shorewall-1.4.7c.ebuild,v 1.3 2003/12/06 23:24:37 weeve Exp $

DESCRIPTION="Full state iptables firewall"
HOMEPAGE="http://www.shorewall.net/"
SRC_URI="ftp://slovakia.shorewall.net/mirror/shorewall/${PN}-${PV}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~alpha"

DEPEND="virtual/glibc
	net-firewall/iptables
	sys-apps/iproute"

S=${WORKDIR}/${P}

src_install() {
	keepdir /var/lib/shorewall
	PREFIX=${D} ./install.sh /etc/init.d || die

	exeinto /etc/init.d
	newexe ${FILESDIR}/shorewall shorewall
	dohtml -r documentation/*
}

pkg_postinst() {
	einfo "Read the documentation from http://www.shorewall.net"
	einfo "available at /usr/share/doc/${PF}/html/index.htm"
	einfo "and edit the files in /etc/shorewall before starting the firewall"
}
