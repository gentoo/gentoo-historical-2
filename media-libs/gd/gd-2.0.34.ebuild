# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gd/gd-2.0.34.ebuild,v 1.1 2007/02/07 03:16:15 vapier Exp $

DESCRIPTION="A graphics library for fast image creation"
HOMEPAGE="http://libgd.org/"
SRC_URI="http://libgd.org/releases/${P}.tar.bz2"

LICENSE="|| ( as-is BSD )"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="fontconfig jpeg png truetype xpm"

DEPEND="fontconfig? ( media-libs/fontconfig )
	jpeg? ( >=media-libs/jpeg-6b )
	png? ( >=media-libs/libpng-1.2.5 sys-libs/zlib )
	truetype? ( >=media-libs/freetype-2.1.5 )
	xpm? ( x11-libs/libXpm x11-libs/libXt )"

src_compile() {
	econf \
		$(use_with fontconfig) \
		$(use_with png) \
		$(use_with truetype freetype) \
		$(use_with jpeg) \
		$(use_with xpm) \
		|| die
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc INSTALL README*
	dohtml -r ./
}
