# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-gnustep/terminal/terminal-0.9.4.ebuild,v 1.4 2004/04/17 19:43:33 aliz Exp $

inherit gnustep

S=${WORKDIR}/${P/t/T}

DESCRIPTION="GNUstep terminal emulator"
HOMEPAGE="http://www.nongnu.org/terminal/"
SRC_URI="http://savannah.nongnu.org/download/terminal/Terminal.pkg/${PV}/${P/t/T}.tar.gz"
IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=dev-util/gnustep-gui-0.8.5"

src_unpack() {
	unpack ${P/t/T}.tar.gz
	cd ${S}
}
