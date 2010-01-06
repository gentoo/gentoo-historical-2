# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gavl/gavl-1.1.0.ebuild,v 1.3 2010/01/06 23:34:40 josejx Exp $

EAPI=2
inherit autotools

DESCRIPTION="library for handling uncompressed audio and video data"
HOMEPAGE="http://gmerlin.sourceforge.net"
SRC_URI="mirror://sourceforge/gmerlin/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="doc"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	sed -e 's:-mfpmath=387::g' \
		-e 's:-O3 -funroll-all-loops -fomit-frame-pointer -ffast-math::g' \
		-i configure.ac || die "sed failed"
	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	# --disable-libpng because it's only used for tests
	econf \
		--docdir=/usr/share/doc/${PF}/html \
		--disable-dependency-tracking \
		--disable-libpng \
		$(use_with doc doxygen) \
		--without-cpuflags
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS README TODO
}
