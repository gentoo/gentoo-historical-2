# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/flphoto/flphoto-1.2.ebuild,v 1.2 2004/03/30 12:15:25 aliz Exp $

DESCRIPTION="Basic image management and display program based on the FLTK toolkit"
HOMEPAGE="http://www.easysw.com/~mike/flphoto/"
SRC_URI="mirror://sourceforge/fltk/${P}-source.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cups gphoto2"

DEPEND=">=x11-libs/fltk-1.1.4
	cups? ( net-print/cups )
	gphoto2? ( media-gfx/gphoto2 )"

MAKEOPTS="${MAKEOPTS} -j1"

src_install() {
	make DESTDIR=${D} install || die
}
