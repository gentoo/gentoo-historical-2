# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dibbler/dibbler-0.4.1.ebuild,v 1.4 2010/10/28 09:59:52 ssuominen Exp $

inherit eutils

DESCRIPTION="Portable DHCPv6 implementation (server, client and relay)"
HOMEPAGE="http://klub.com.pl/dhcpv6/"
SRC_URI="http://klub.com.pl/dhcpv6/dibbler/${P}-src.tar.gz
		doc? ( http://klub.com.pl/dhcpv6/dibbler/${P}-doc.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~hppa"
IUSE="doc"
DEPEND=""

DIBBLER_DOCDIR=${WORKDIR}/doc

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-gcc-4.1.patch
}

src_compile() {
	emake server client relay || die
}

src_install() {
	dosbin dibbler-server
	dosbin dibbler-client
	dosbin dibbler-relay
	doman doc/man/dibbler-server.8 doc/man/dibbler-client.8 doc/man/dibbler-relay.8
	dodoc CHANGELOG RELNOTES

	insinto /etc/dibbler
	doins *.conf
	dodir /var/lib/dibbler
	use doc && dodoc ${DIBBLER_DOCDIR}/dibbler-user.pdf \
			${DIBBLER_DOCDIR}/dibbler-devel.pdf
	doinitd "${FILESDIR}"/dibbler-server \
			"${FILESDIR}"/dibbler-client \
			"${FILESDIR}"/dibbler-relay
}

pkg_postinst() {
	einfo "Make sure that you modify client.conf, server.conf and/or relay.conf "
	einfo "to suit your needs. They are stored in /etc/dibbler."
}
