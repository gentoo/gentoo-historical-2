# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ldapdns/ldapdns-2.06.ebuild,v 1.5 2007/05/06 08:56:52 genone Exp $

inherit eutils

DESCRIPTION="A tiny, fast authoritative nameserver that queries LDAP and can be updated instantly"
HOMEPAGE="http://www.nimh.org/code/ldapdns/"
SRC_URI="http://www.nimh.org/dl/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND="virtual/libc
	>=net-nds/openldap-2"
RDEPEND="${DEPEND}
	>=sys-process/daemontools-0.70
	sys-apps/ucspi-tcp"

pkg_setup() {
	enewgroup nofiles
	enewuser ldapdns -1 -1 /nonexistent nofiles
	enewuser dnslog -1 -1 /nonexistent nofiles
}

src_unpack() {
	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	local myconf="--prefix=/usr "

	cd ${S}
	./configure ${myconf}
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS CHANGELOG FAQ INSTALL COPYING NEWS README* TODO
}

pkg_postinst() {
	elog "Read the readme.configure and use ldapdns-conf to setup"
}
