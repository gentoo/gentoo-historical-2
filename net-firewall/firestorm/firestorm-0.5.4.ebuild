# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/firestorm/firestorm-0.5.4.ebuild,v 1.4 2004/06/24 22:39:00 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Network IDS"
SRC_URI="http://www.scaramanga.co.uk/firestorm/v${PV}/${P}.tar.gz"
HOMEPAGE="http://www.scaramanga.co.uk/firestorm/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 s390 ~ppc"

DEPEND="virtual/glibc"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING CREDITS ChangeLog HACKING INSTALL NEWS README
}
