# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/aqhbci/aqhbci-0.9.14_beta.ebuild,v 1.1 2004/12/21 17:08:50 hanno Exp $

DESCRIPTION="HBCI backend for AqBanking"
HOMEPAGE="http://www.aqmaniac.de/aqbanking/"
SRC_URI="mirror://sourceforge/aqhbci/${P/_/}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"
DEPEND=">=net-libs/aqbanking-0.9.6"
S=${WORKDIR}/${P/_/}

# Fails with parallel make
MAKEOPTS="-j1"

src_compile() {
	econf `use_enable debug` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS README TODO README COPYING NEWS
}
