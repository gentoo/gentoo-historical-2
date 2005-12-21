# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gd/gd-2.0.33.ebuild,v 1.3 2005/12/21 07:03:51 halcy0n Exp $

inherit eutils

DESCRIPTION="A graphics library for fast image creation"
HOMEPAGE="http://www.boutell.com/gd/"
SRC_URI="http://www.boutell.com/gd/http/${P}.tar.gz"

LICENSE="|| ( as-is BSD )"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ppc64 ~s390 ~sparc x86"
IUSE="fontconfig jpeg png X truetype"

DEPEND="fontconfig? ( media-libs/fontconfig )
	jpeg? ( >=media-libs/jpeg-6b )
	png? ( >=media-libs/libpng-1.2.5 sys-libs/zlib )
	truetype? ( >=media-libs/freetype-2.1.5 )
	X? ( virtual/x11 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-overflow-checks.patch
}

src_compile() {
	econf \
		$(use_with fontconfig) \
		$(use_with png) \
		$(use_with truetype freetype) \
		$(use_with jpeg) \
		$(use_with X xpm) \
		|| die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc INSTALL README*
	dohtml -r ./
}
