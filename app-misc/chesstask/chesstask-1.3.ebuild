# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/chesstask/chesstask-1.3.ebuild,v 1.6 2004/05/17 15:25:03 usata Exp $

inherit eutils

S=${WORKDIR}/${PN}${PV/./_}
DESCRIPTION="An editor for chess problems. It will generate PostScript and HTML files."
HOMEPAGE="http://chesstask.sourceforge.net/"
SRC_URI="mirror://sourceforge/chesstask/ChessTask${PV/./_}src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc"

DEPEND=">=x11-libs/qt-3
	virtual/tetex"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/Makefile-1.3.diff
}


src_compile() {
	emake || die
}

src_install() {
	dobin ChessTask
}
