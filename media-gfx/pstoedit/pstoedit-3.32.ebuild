# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pstoedit/pstoedit-3.32.ebuild,v 1.3 2002/11/14 18:08:19 vapier Exp $

inherit libtool

IUSE="flash"

S=${WORKDIR}/${P}
DESCRIPTION="translates PostScript and PDF graphics into other vector formats"
SRC_URI="http://home.t-online.de/home/helga.glunz/wglunz/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.pstoedit.net/pstoedit"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

DEPEND="media-libs/libpng
	sys-libs/zlib
	flash? ( media-libs/ming )"

RDEPEND="${DEPEND}
	app-text/ghostscript"

src_compile() {
	elibtoolize
	econf
	make || die
}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc readme.txt copying 
	dodoc changelog.htm
}
