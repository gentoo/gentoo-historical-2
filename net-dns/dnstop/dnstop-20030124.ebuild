# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnstop/dnstop-20030124.ebuild,v 1.3 2004/06/24 22:35:12 agriffis Exp $

DESCRIPTION="Displays various tables of DNS traffic on your network."
HOMEPAGE="http://dnstop.measurement-factory.com/"
SRC_URI="http://dnstop.measurement-factory.com/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc"

IUSE=""
DEPEND=">=net-libs/libpcap-0.7.1-r2"

S=${WORKDIR}

src_compile() {
	cp Makefile Makefile.orig
	sed -e "s:^CFLAGS=.*$:CFLAGS=${CFLAGS} -DUSE_PPP:" \
		Makefile.orig > Makefile

	emake || die
}

src_install() {
	dobin dnstop
	doman dnstop.8
	dodoc LICENSE
}
