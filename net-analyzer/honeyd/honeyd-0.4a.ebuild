# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/honeyd/honeyd-0.4a.ebuild,v 1.1 2003/02/12 10:45:18 aliz Exp $

DESCRIPTION="Honeyd is a small daemon that creates virtual hosts on a network"
HOMEPAGE="http://www.citi.umich.edu/u/provos/honeyd/"
SRC_URI="http://www.citi.umich.edu/u/provos/honeyd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND=">=libdnet-1.4
	>=libevent-0.6
	>=libpcap-0.7.1"
RDEPEND=${DEPEND}

S="${WORKDIR}/${P}"

src_compile() {
	./configure \
		--with-libdnet=/usr || die "./configure failed"
	emake CFLAGS="${CFLAGS}"|| die
}

src_install() {
	doman honeyd.8
	dosbin honeyd

	dodir /usr/share/honeyd/scripts

	insinto /usr/share/honeyd
	doins nmap.prints config.sample

	exeinto /usr/share/honeyd/scripts
	doexe scripts/web.sh scripts/router-telnet.pl scripts/test.sh
}

