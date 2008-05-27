# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/rbldnsd/rbldnsd-0.996b.ebuild,v 1.1 2008/05/27 07:42:08 jer Exp $

inherit eutils
DESCRIPTION="a DNS daemon which is designed to serve DNSBL zones"
HOMEPAGE="http://www.corpit.ru/mjt/rbldnsd.html"
SRC_URI="http://www.corpit.ru/mjt/rbldnsd/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="ipv6 zlib"

RDEPEND="zlib? ( sys-libs/zlib )"
DEPEND=""

src_compile() {
	# econf doesn't work
	./configure \
		$(use_enable ipv6) \
		$(use_enable zlib) || "./configure failed"

	emake || die "emake failed"
}

src_install() {
	dosbin rbldnsd
	doman rbldnsd.8
	keepdir /var/db/rbldnsd
	dodoc CHANGES* TODO NEWS README* "${FILESDIR}"/example
	newinitd "${FILESDIR}"/initd rbldnsd
	newconfd "${FILESDIR}"/confd rbldnsd
}

pkg_postinst() {
	enewgroup rbldns
	enewuser rbldns -1 -1 /var/db/rbldnsd rbldns
	chown rbldns:rbldns /var/db/rbldnsd

	elog "for testing purpose, example zone file has been installed"
	elog "see /usr/share/doc/${PF}/example.gz"
}
