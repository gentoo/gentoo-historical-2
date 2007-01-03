# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/tac_plus/tac_plus-4.0.4.14.ebuild,v 1.1 2007/01/03 13:09:37 chainsaw Exp $

MY_P="tacacs+-F${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="An updated version of Cisco's TACACS+ server"
HOMEPAGE="http://www.shrubbery.net/tac_plus/"
SRC_URI="ftp://ftp.shrubbery.net/pub/tac_plus/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug finger tcpd skey"

DEPEND="skey? ( >=app-admin/skey-1.1.5-r1 )
	tcpd? ( sys-apps/tcp-wrappers )"

src_compile() {
	econf \
		`use_with skey` \
		`use_with tcpd libwrap` \
		`use_enable finger` \
		`use_enable debug` \
		|| die "econf failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc CHANGES FAQ
	newinitd ${FILESDIR}/tac_plus.init tac_plus
	newconfd ${FILESDIR}/tac_plus.confd tac_plus
	insinto /etc/tac_plus
	newins ${FILESDIR}/tac_plus.conf tac_plus.conf || die
}
