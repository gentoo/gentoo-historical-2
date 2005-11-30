# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/dvipng/dvipng-1.5.ebuild,v 1.1.1.1 2005/11/30 10:06:49 chriswhite Exp $

IUSE="truetype"
DESCRIPTION="A program to translate a DVI (DeVice Independent) files into PNG (Portable Network Graphics) bitmaps"
HOMEPAGE="http://dvipng.sourceforge.net/"
KEYWORDS="~x86"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="media-libs/gd
	media-libs/libpng
	sys-libs/zlib
	truetype? ( >=media-libs/freetype-2.1.5 )"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

src_compile() {
	econf \
		$(use_with truetype freetype) \
		|| die "Configure failed"
	emake || die "Compile failed"
}

src_install() {
	make DESTDIR=${D} install || die "Install failed"

	dodoc ChangeLog INSTALL README RELEASE || die "dodoc failed"
}
