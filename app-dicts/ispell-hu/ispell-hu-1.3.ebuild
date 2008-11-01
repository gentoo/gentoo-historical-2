# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-hu/ispell-hu-1.3.ebuild,v 1.1 2008/11/01 09:47:11 pva Exp $

inherit eutils

MY_P=magyarispell-${PV}
DESCRIPTION="Hungarian dictionary for Ispell"
HOMEPAGE="http://magyarispell.sourceforge.net/"
SRC_URI="mirror://sourceforge/magyarispell/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 LGPL-2.1 MPL-1.1 )"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
SLOT="0"

DEPEND="app-text/ispell
	app-text/recode"

IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() {
	make magyar4ispell.hash || die
}

src_install () {
	insinto /usr/lib/ispell

	doins tmp/magyar.aff || die
	newins tmp/magyar4ispell.hash magyar.hash || die
	dosym /usr/lib/ispell/magyar.hash /usr/lib/ispell/hungarian.hash

	dodoc ChangeLog GYIK README OLVASSEL
}
