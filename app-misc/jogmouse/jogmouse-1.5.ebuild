# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/jogmouse/jogmouse-1.5.ebuild,v 1.11 2004/06/14 09:08:40 kloeri Exp $

DESCRIPTION="Utility to use VAIO JogDial as a scrollwheel under X."
SRC_URI="http://nerv-un.net/~dragorn/jogmouse/${P}.tar.gz"
HOMEPAGE="http://nerv-un.net/~dragorn/jogmouse/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -ppc -sparc"
IUSE=""

DEPEND="virtual/x11"

src_compile() {
	emake || die
}

src_install() {
	dobin jogmouse
	dodoc README
}
