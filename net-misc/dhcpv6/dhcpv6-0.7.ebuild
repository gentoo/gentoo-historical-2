# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dhcpv6/dhcpv6-0.7.ebuild,v 1.4 2003/07/13 14:31:36 aliz Exp $

DESCRIPTION="Server and client for DHCPv6"

MY_P=${P/dhcpv6/dhcp6}
HOMEPAGE="http://www.sourceforge.net/projects/dhcp6/"
SRC_URI="mirror://sourceforge/dhcpv6/${MY_P}.tgz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86"
IUSE=""
DEPEND=""
S=${WORKDIR}/${MY_P}

src_install() {
	einstall || die
	dodoc ReadMe docs/draft-ietf-dhc-dhcpv6-28.txt \
		docs/draft-ietf-dhc-dhcpv6-interop-{00,01}.txt \
		docs/draft-ietf-dhc-dhcpv6-opt-dnsconfig-03.txt \
		docs/draft-ietf-dhc-dhcpv6-opt-prefix-delegation-{02,03}.txt \
		dhcp6c.conf dhcp6s.conf
	dodir /var/lib/dhcpv6
	exeinto /etc/init.d
	newexe ${FILESDIR}/dhcp6s.rc dhcp6s
}
pkg_postinst() {
	einfo "Sample dhcp6c.conf and dhcp6s.conf files are in"
	einfo "/usr/share/doc/${P}/"
}
