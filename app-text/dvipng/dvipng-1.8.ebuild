# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvipng/dvipng-1.8.ebuild,v 1.3 2006/06/19 06:33:28 corsair Exp $

IUSE="truetype"
DESCRIPTION="A program to translate a DVI (DeVice Independent) files into PNG (Portable Network Graphics) bitmaps"
HOMEPAGE="http://dvipng.sourceforge.net/"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="media-libs/gd
	media-libs/libpng
	virtual/tetex
	sys-libs/zlib
	truetype? ( >=media-libs/freetype-2.1.5 )"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

src_compile() {
	econf $(use_with truetype freetype) || die "Configure failed"
	emake || die "Compile failed"
}

src_install() {
	make DESTDIR=${D} install || die "Install failed"

	dodoc ChangeLog README RELEASE || die "dodoc failed"
}
