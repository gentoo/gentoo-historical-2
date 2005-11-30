# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/accessx/accessx-0950-r1.ebuild,v 1.1.1.1 2005/11/30 09:40:18 chriswhite Exp $

inherit eutils

S=${WORKDIR}/${PN}
DESCRIPTION="Interface to the XKEYBOARD extension in X11"
SRC_URI="http://cmos-eng.rehab.uiuc.edu/accessx/software/${PN}${PV}.tar.gz"
HOMEPAGE="http://cmos-eng.rehab.uiuc.edu/accessx/"
IUSE=""

DEPEND="virtual/x11
	dev-lang/tk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/access-gcc3-gentoo.patch
}

src_compile() {
	make || die
}

src_install () {
	into /usr
	dobin accessx ax || die
	dodoc README INSTALL CHANGES
}
