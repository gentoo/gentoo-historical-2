# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/devil/devil-1.7.8.ebuild,v 1.1 2010/05/10 20:50:06 ssuominen Exp $

EAPI=2
inherit eutils

MY_P=DevIL-${PV}

DESCRIPTION="DevIL image library"
HOMEPAGE="http://openil.sourceforge.net/"
SRC_URI="mirror://sourceforge/openil/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="openexr gif jpeg lcms mng png tiff xpm allegro opengl sdl X"

RDEPEND="gif? ( media-libs/giflib )
	openexr? ( media-libs/openexr )
	jpeg? ( media-libs/jpeg )
	lcms? ( media-libs/lcms )
	mng? ( media-libs/libmng )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	xpm? ( x11-libs/libXpm )
	allegro? ( media-libs/allegro )
	opengl? ( virtual/glu )
	sdl? ( media-libs/libsdl )
	X? ( x11-libs/libXext
		 x11-libs/libX11
		 x11-libs/libXrender )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xextproto )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-{CVE-2009-3994,libpng14}.patch
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-ILU \
		--enable-ILUT \
		$(use_enable gif) \
		$(use_enable jpeg) \
		$(use_enable lcms) \
		$(use_enable mng) \
		$(use_enable openexr exr) \
		$(use_enable png) \
		$(use_enable tiff) \
		$(use_enable xpm) \
		$(use_enable allegro) \
		$(use_enable opengl) \
		$(use_enable sdl) \
		$(use_with X x) \
		$(use_enable X x11) \
		$(use_enable X shm) \
		$(use_enable X render) \
		--disable-directx8 \
		--disable-directx9
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS CREDITS ChangeLog NEWS README* TODO || die
}
