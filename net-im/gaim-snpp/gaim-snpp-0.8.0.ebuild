# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/gaim-snpp/gaim-snpp-0.8.0.ebuild,v 1.3 2005/02/21 21:51:44 blubb Exp $

inherit debug

DESCRIPTION="gaim-snpp is an SNPP protocol plug-in for Gaim"
HOMEPAGE="http://gaim-snpp.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

DEPEND=">=net-im/gaim-1.0.0"
#RDEPEND=""

src_install() {
	make install DESTDIR=${D} || die "install failure"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS PROTOCOL README VERSION
}
