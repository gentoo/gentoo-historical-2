# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ethstatus/ethstatus-0.4.2-r2.ebuild,v 1.4 2005/06/26 03:58:36 vanquirius Exp $

DESCRIPTION="ncurses based utility to display real time statistics about network traffic."
HOMEPAGE="http://ethstatus.calle69.net/"
SRC_URI="mirror://debian/pool/main/e/ethstatus/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.4-r1"

src_compile()
{
	emake CFLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install()
{
	dobin ethstatus
	doman ethstatus.1
	dodoc CHANGELOG README
}
