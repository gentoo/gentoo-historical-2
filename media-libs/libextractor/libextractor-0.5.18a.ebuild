# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libextractor/libextractor-0.5.18a.ebuild,v 1.3 2007/12/30 15:09:59 armin76 Exp $

inherit libtool

IUSE="gtk nls vorbis zlib"
DESCRIPTION="A simple library for keyword extraction"
HOMEPAGE="http://www.gnunet.org/libextractor/"
SRC_URI="http://gnunet.org/${PN}/download/${P}.tar.gz"
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86"
# Disabled tests because they dont work (tester@g.o)
RESTRICT="test"
DEPEND=">=sys-devel/libtool-1.4.1
	>=dev-libs/glib-2.0.0
	media-libs/libmpeg2
	nls? ( virtual/libintl )
	gtk? ( >=x11-libs/gtk+-2.6.10 )
	zlib? ( sys-libs/zlib )
	vorbis? ( >=media-libs/libvorbis-1.0_beta4 )"
RDEPEND=""
MAKEOPTS="${MAKEOPTS} -j1"

src_compile() {
	elibtoolize
	#bug #188169 -> --disable-xpdf
	econf --enable-glib --enable-exiv2 \
		--disable-xpdf \
		$(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
}
