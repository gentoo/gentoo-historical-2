# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/exiftags/exiftags-0.97.ebuild,v 1.7 2004/07/01 10:48:47 eradicator Exp $

DESCRIPTION="Extracts JPEG EXIF headers from digital camera photos"
HOMEPAGE="http://johnst.org/sw/exiftags/"
SRC_URI="http://johnst.org/sw/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="virtual/libc"

src_compile() {
	make || die "make failed"
}

src_install() {
	dobin exiftags exifcom || die
	doman exiftags.1 exifcom.1
	dodoc README CHANGES
}
