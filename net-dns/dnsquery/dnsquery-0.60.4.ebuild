# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnsquery/dnsquery-0.60.4.ebuild,v 1.2 2004/04/23 10:32:00 dholm Exp $

DESCRIPTION="A graphical tool for sending queries to DNS servers"
HOMEPAGE="http://www.posadis.org/projects/dnsquery.php"
SRC_URI="mirror://sourceforge/posadis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND=">=dev-cpp/poslib-1.0.2
	=x11-libs/gtk+-1.2*"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
