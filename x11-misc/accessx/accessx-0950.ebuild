# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# John Stalker <stalker@math.princeton.edu>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/accessx/accessx-0950.ebuild,v 1.11 2004/06/24 22:10:34 agriffis Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Interface to the XKEYBOARD extension in X11"
SRC_URI="http://cmos-eng.rehab.uiuc.edu/accessx/software/${PN}${PV}.tar.gz"
HOMEPAGE="http://cmos-eng.rehab.uiuc.edu/accessx/"

DEPEND="virtual/x11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc"

src_compile() {
	make || die
}

src_install () {
	into /usr
	dobin accessx ax || die
	dodoc README INSTALL CHANGES
}
