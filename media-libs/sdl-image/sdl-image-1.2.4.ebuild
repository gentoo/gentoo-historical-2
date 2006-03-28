# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-image/sdl-image-1.2.4.ebuild,v 1.6 2006/03/28 05:12:10 vapier Exp $

inherit flag-o-matic

MY_P="${P/sdl-/SDL_}"
DESCRIPTION="image file loading library"
HOMEPAGE="http://www.libsdl.org/projects/SDL_image/index.html"
SRC_URI="http://www.libsdl.org/projects/SDL_image/release/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="gif jpeg tiff png"

DEPEND="sys-libs/zlib
	>=media-libs/libsdl-1.2.4
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b )
	tiff? ( media-libs/tiff )"

S=${WORKDIR}/${MY_P}

src_compile() {
	econf \
		--disable-dependency-tracking \
		$(use_enable gif) \
		$(use_enable jpeg jpg) \
		$(use_enable tiff tif) \
		$(use_enable png) \
		$(use_enable png pnm) \
		--enable-bmp \
		--enable-lbm \
		--enable-pcx \
		--enable-tga \
		--enable-xcf \
		--enable-xpm \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dobin .libs/showimage || die "dobin failed"
	dodoc CHANGES README
}
