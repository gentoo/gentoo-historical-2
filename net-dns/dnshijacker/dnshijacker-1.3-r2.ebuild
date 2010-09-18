# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnshijacker/dnshijacker-1.3-r2.ebuild,v 1.1 2010/09/18 23:24:50 jer Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="a libnet/libpcap based packet sniffer and spoofer"
HOMEPAGE="http://pedram.redhive.com/projects.php"
SRC_URI="http://pedram.redhive.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-libs/libpcap
	>=net-libs/libnet-1.0.2a-r3
	<net-libs/libnet-1.1"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-libnet-1.0.patch
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dosbin dnshijacker ask_dns answer_dns

	insinto /etc/dnshijacker
	doins ftable

	dodoc README
}
