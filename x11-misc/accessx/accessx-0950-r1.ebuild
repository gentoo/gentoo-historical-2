# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# John Stalker <stalker@math.princeton.edu>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/accessx/accessx-0950-r1.ebuild,v 1.4 2002/10/20 18:55:28 vapier Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Interface to the XKEYBOARD extension in X11"
SRC_URI="http://cmos-eng.rehab.uiuc.edu/accessx/software/${PN}${PV}.tar.gz"
HOMEPAGE="http://cmos-eng.rehab.uiuc.edu/accessx/"

DEPEND="virtual/x11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc sparc64"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 <${FILESDIR}/access-gcc3-gentoo.patch || die
}

src_compile() {
	make || die
}

src_install () {
	into /usr
	dobin accessx ax || die
	dodoc README INSTALL CHANGES
}
