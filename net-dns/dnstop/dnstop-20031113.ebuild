# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnstop/dnstop-20031113.ebuild,v 1.1 2004/01/23 22:44:38 blkdeath Exp $

DESCRIPTION="Displays various tables of DNS traffic on your network."
HOMEPAGE="http://dnstop.measurement-factory.com/"
SRC_URI="http://dnstop.measurement-factory.com/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~sparc x86"

IUSE=""
DEPEND="ncurses libpcap"

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
