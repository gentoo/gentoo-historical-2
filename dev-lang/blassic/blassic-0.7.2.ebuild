# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/blassic/blassic-0.7.2.ebuild,v 1.2 2003/09/28 07:20:20 mr_bones_ Exp $

DESCRIPTION="classic Basic interpreter"
HOMEPAGE="http://www.arrakis.es/~ninsesabe/blassic/index.html"
SRC_URI="http://www.arrakis.es/~ninsesabe/blassic/${P}.tgz"

KEYWORDS="x86 ~ppc ~hppa"
LICENSE="GPL-2"
SLOT="0"

IUSE="svga"

DEPEND="virtual/x11
	sys-libs/ncurses
	svga? ( media-libs/svgalib )"

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README THANKS TODO
}
