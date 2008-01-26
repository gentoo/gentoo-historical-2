# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/exiftags/exiftags-1.01.ebuild,v 1.5 2008/01/26 10:59:23 grobian Exp $

inherit toolchain-funcs

DESCRIPTION="Extracts JPEG EXIF headers from digital camera photos"
HOMEPAGE="http://johnst.org/sw/exiftags/"
SRC_URI="http://johnst.org/sw/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed."
}

src_install() {
	dobin exiftags exifcom exiftime || die "dobin failed."
	doman exiftags.1 exifcom.1 exiftime.1
	dodoc README CHANGES
}
