# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnsmasq/dnsmasq-2.8.ebuild,v 1.4 2004/07/14 23:24:50 agriffis Exp $

DESCRIPTION="Small forwarding DNS server for local networks"
HOMEPAGE="http://www.thekelleys.org.uk/dnsmasq/"

MY_P="${P/_/}"
MY_PV="${PV/_rc*/}"
SRC_URI="http://www.thekelleys.org.uk/dnsmasq/${MY_P}.tar.gz"

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~ia64 ~amd64 ~mips s390"
IUSE=""

DEPEND="virtual/libc
	>=sys-apps/sed-4"


S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i "s:-O2:\"${CFLAGS}\":" Makefile
	sed -i "s:-O2:\"${CFLAGS}\":" src/Makefile
}

src_compile() {
	emake || die
}

src_install() {
	dosbin src/dnsmasq
	doman dnsmasq.8
	dodoc CHANGELOG COPYING FAQ
	dohtml *.html

	exeinto /etc/init.d
	newexe ${FILESDIR}/dnsmasq-init dnsmasq
	insinto /etc/conf.d
	newins ${FILESDIR}/dnsmasq.confd dnsmasq
}
