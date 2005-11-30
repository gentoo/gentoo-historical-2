# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcms/wmcms-0.3.5.ebuild,v 1.1.1.1 2005/11/30 10:10:55 chriswhite Exp $

IUSE=""

DESCRIPTION="WindowMaker CPU and Memory Usage Monitor Dock App."
SRC_URI="http://orbita.starmedia.com/~neofpo/files/${P}.tar.bz2"
HOMEPAGE="http://orbita.starmedia.com/~neofpo/wmcms.html"

DEPEND="x11-libs/libdockapp"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc amd64 ppc"

src_compile() {
	make || die
}

src_install () {
	dobin wmcms
}
