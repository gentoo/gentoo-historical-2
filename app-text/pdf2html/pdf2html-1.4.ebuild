# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pdf2html/pdf2html-1.4.ebuild,v 1.6 2004/06/24 22:47:10 agriffis Exp $

inherit eutils

DESCRIPTION="Converts pdf files to html files"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/local/clock/pdf2html/${P}.tgz"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~clock/twibright/pdf2html/"
LICENSE="GPL-2"

KEYWORDS="x86 ~alpha"
IUSE=""
SLOT="0"

DEPEND=">=media-libs/libpng-1.2.5
	virtual/ghostscript
	>=sys-libs/zlib-1.1.4
	>=media-gfx/imagemagick-5.4.9"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "Compile has failed"
	echo "cp /usr/share/${P}/*.png ." >> pdf2html
}

src_install() {
	dobin pbm2png pbm2eps9 pdf2html ps2eps9  || die "install failed"

	insinto /usr/share/${P}
	doins *.png *.html

	dodoc CHANGELOG INSTALL README VERSION || die "install failed"
}
