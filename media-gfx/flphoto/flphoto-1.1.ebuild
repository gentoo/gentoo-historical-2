# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/flphoto/flphoto-1.1.ebuild,v 1.4 2004/06/24 22:37:32 agriffis Exp $

DESCRIPTION="Basic image management and display program based on the FLTK toolkit"
HOMEPAGE="http://www.easysw.com/~mike/flphoto/"
SRC_URI="mirror://sourceforge/fltk/${P}-source.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86"
IUSE="cups gphoto2"
S="${WORKDIR}/${P}"

DEPEND=">=x11-libs/fltk-1.1.2-r2
	cups? ( net-print/cups )
	gphoto2? ( media-gfx/gphoto2 )"

MAKEOPTS="${MAKEOPTS} -j1"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
