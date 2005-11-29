# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/dbench/dbench-2.0.ebuild,v 1.16 2005/11/29 04:32:10 jer Exp $

DESCRIPTION="Popular filesystem benchmark"
SRC_URI="ftp://samba.org/pub/tridge/dbench/${P}.tar.gz"
HOMEPAGE="ftp://samba.org/pub/tridge/dbench/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ppc sparc x86"
IUSE=""
DEPEND="sys-apps/sed"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:-O2 -Wall:${CFLAGS}:g" Makefile
}

src_compile() {
	emake
}

src_install() {
	dobin dbench tbench tbench_srv
	dodoc README results.txt
	insinto /usr/share/dbench
	doins client_plain.txt client_oplocks.txt
	doman dbench.1
}

pkg_postinst() {
	einfo "dbench info:"
	einfo "You can find the client_*.txt file in ${ROOT}usr/share/dbench."
	echo
}
