# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/dcraw/dcraw-8.39.ebuild,v 1.3 2007/04/30 21:21:25 genone Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Converts the native (RAW) format of various digital cameras into netpbm portable pixmap (.ppm) image"
HOMEPAGE="http://www.cybercom.net/~dcoffin/dcraw/"
SRC_URI="http://dev.gentoo.org/~wschlich/src/media-gfx/dcraw/${P}.tar.bz2"
LICENSE="freedist GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
DEPEND="virtual/libc
	>=media-libs/jpeg-6b
	media-libs/lcms"
RDEPEND="${DEPEND}
	media-libs/netpbm"

src_compile() {
	emake CC=$(tc-getCC) || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc doc/conversion-examples.txt doc/dcwrap
}

pkg_postinst() {
	elog ""
	elog "See conversion-examples.txt.gz on how to convert"
	elog "the PPM files produced by dcraw to other image formats."
	elog ""
	ewarn "The functionality of the external program 'fujiturn' was"
	ewarn "incoporated into dcraw and is automatically used now."
	elog ""
	elog "There's an example wrapper script included called 'dcwrap'."
	elog ""
	elog "This package also includes 'dcparse', which extracts"
	elog "thumbnail images (preferably JPEGs) from any raw digital"
	elog "camera formats that have them, and shows table contents."
	elog ""
}
