# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/jam/jam-2.5.ebuild,v 1.2 2004/03/13 01:49:46 mr_bones_ Exp $

DESCRIPTION="Just Another Make - advanced make replacement"
SRC_URI="ftp://ftp.perforce.com/pub/jam/${P}.tar"
HOMEPAGE="http://www.perforce.com/jam/jam.html"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc"

DEPEND="dev-util/yacc"

src_compile() {
	# The bootstrap makefile assumes ${S} is in the path
	env PATH="${PATH}:${S}" make CFLAGS="${CFLAGS}" || die
}

src_install() {
	BINDIR="${D}/usr/bin" ./jam0 install || die
	dohtml Jam.html Jambase.html Jamfile.html
	dodoc README RELNOTES Porting
}
