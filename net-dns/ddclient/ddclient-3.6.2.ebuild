# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ddclient/ddclient-3.6.2.ebuild,v 1.14 2004/06/24 22:33:54 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A perl based client for dyndns"
SRC_URI="http://burry.ca:4141/ddclient/${P}.tar.gz"
HOMEPAGE="http://burry.ca:4141/ddclient/"

RDEPEND="dev-lang/perl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ppc ~alpha"

src_unpack() {
	unpack ${P}.tar.gz
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
}
src_install () {

	exeinto /usr/sbin
	doexe ddclient
	insinto /etc/ddclient
	doins sample-*
	dodoc README COPYING COPYRIGHT
	exeinto /etc/init.d
	newexe ${FILESDIR}/ddclient.rc6 ddclient
}

