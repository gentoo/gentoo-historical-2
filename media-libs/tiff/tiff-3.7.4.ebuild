# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tiff/tiff-3.7.4.ebuild,v 1.4 2006/05/01 03:29:28 nerdboy Exp $

inherit eutils libtool

DESCRIPTION="Library for manipulation of TIFF (Tag Image File Format) images"
HOMEPAGE="http://www.libtiff.org/"
SRC_URI="ftp://ftp.remotesensing.org/pub/libtiff/old/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ~ppc-macos ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="jpeg nocxx zlib"

DEPEND="jpeg? ( >=media-libs/jpeg-6b )
	zlib? ( >=sys-libs/zlib-1.1.3-r2 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-assign-dont-compare.patch

	elibtoolize
}

src_compile() {
	econf \
		$(use_enable !nocxx cxx) \
		$(use_enable zlib) \
		$(use_enable jpeg) \
		--without-x \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc README TODO VERSION
}
