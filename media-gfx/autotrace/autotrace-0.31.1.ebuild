# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/autotrace/autotrace-0.31.1.ebuild,v 1.7 2004/08/07 23:12:44 slarti Exp $

DESCRIPTION="Converts Bitmaps to vector-graphics"
SRC_URI="mirror://sourceforge/autotrace/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://autotrace.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE=""

DEPEND=">=x11-libs/gtkDPS-0.3.3
	media-libs/libexif
	>=x11-libs/gtk+-1.2.10-r4"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README
}
