# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/jam/jam-2.4.ebuild,v 1.4 2003/02/13 11:56:55 vapier Exp $

DESCRIPTION="jam (Just Another Make) - advanced make replacement"
SRC_URI="ftp://ftp.perforce.com/pub/jam/${P}.zip"
HOMEPAGE="http://www.perforce.com/jam/jam.html"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"

DEPEND="dev-util/yacc
	app-arch/unzip"

src_compile() {
	# The bootstrap makefile assumes ${S} is in the path
	PATH="${PATH}:${S}" make || die
}

src_install() {
	BINDIR="${D}/usr/bin" ./jam0 install
	dohtml Jam.html Jambase.html Jamfile.html
	dodoc README RELNOTES Porting
}
