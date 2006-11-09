# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/pdns-recursor/pdns-recursor-3.1.3-r1.ebuild,v 1.1 2006/11/09 13:10:14 swegener Exp $

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="http://www.powerdns.com/"
SRC_URI="http://downloads.powerdns.com/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/boost-1.33.1"
RDEPEND="${DEPEND}
	!<net-dns/pdns-2.9.20-r1"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-svn-fixes.patch
}

src_compile() {
	filter-flags -ftree-vectorize

	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dosbin pdns_recursor rec_control || die "dosbin failed"
	doman pdns_recursor.1 rec_control.1 || die "doman failed"

	insinto /etc/powerdns
	doins "${FILESDIR}"/recursor.conf || die "doins failed"

	doinitd "${FILESDIR}"/precursor || die "doinitd failed"

	keepdir /var/empty
}
