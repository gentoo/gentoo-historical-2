# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/jpegpixi/jpegpixi-0.16.0.ebuild,v 1.1 2004/08/25 06:08:24 eldad Exp $

DESCRIPTION="almost lossless JPEG pixel interpolator, for correcting digital camera defects."
HOMEPAGE="http://www.zero-based.org/software/jpegpixi/"
SRC_URI="http://www.zero-based.org/software/jpegpixi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/jpeg"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	insinto /usr/bin
	dobin jpegpixi jpeghotp

	doman jpegpixi.1 jpeghotp.1

	dodoc AUTHORS NEWS README README.jpeglib
}
