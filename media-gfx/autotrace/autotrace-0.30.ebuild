# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/autotrace/autotrace-0.30.ebuild,v 1.6 2003/02/13 12:29:59 vapier Exp $

DESCRIPTION="Converts Bitmaps to vector-grahics"
SRC_URI="http://ftp1.sourceforge.net/${PN}/${P}.tar.gz"
HOMEPAGE="http://autotrace.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=x11-libs/gtkDPS-0.3.3
	>=x11-libs/gtk+-1.2.10-r4"

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	
	dodoc AUTHORS COPYING ChangeLog NEWS README 
}
