# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmCalClock/wmCalClock-1.25-r1.ebuild,v 1.2 2002/12/09 04:41:57 manson Exp $

S=${WORKDIR}/${P}/Src
DESCRIPTION="WMaker DockApp: A Calendar clock with antialiased text."
SRC_URI="http://nis-www.lanl.gov/~mgh/WindowMaker/${P}.tar.gz"
HOMEPAGE="http://nis-www.lanl.gov/~mgh/WindowMaker/DockApps.shtml"

DEPEND="virtual/x11"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

src_compile() {
	emake || die
}

src_install () {
	dobin ${PN}
	doman ${PN}.1

	cd ..
	dodoc BUGS CHANGES COPYING HINTS INSTALL README TODO
}
