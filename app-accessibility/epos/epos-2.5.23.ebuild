# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/epos/epos-2.5.23.ebuild,v 1.3 2004/06/24 21:21:30 agriffis Exp $

DESCRIPTION="language independent text-to-speech system"
HOMEPAGE="http://epos.ure.cas.cz/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="virtual/glibc"

src_install() {
	einstall || die
	mv ${D}/usr/bin/say ${D}/usr/bin/epos_say
	exeinto /etc/init.d
	doexe ${FILESDIR}/epos
	dodoc WELCOME THANKS Changes ${FILESDIR}/README.gentoo
}
