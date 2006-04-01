# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/devil/devil-1.6.7-r1.ebuild,v 1.7 2006/04/01 19:55:06 agriffis Exp $

inherit eutils

DESCRIPTION="DevIL image library"
HOMEPAGE="http://www.imagelib.org/"
SRC_URI="mirror://sourceforge/openil/DevIL-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ppc ~sparc x86"
IUSE="gif jpeg mng png tiff xpm allegro opengl sdl X"

RDEPEND="gif? ( media-libs/giflib )
	jpeg? ( media-libs/jpeg )
	mng? ( media-libs/libmng )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	xpm? ( || ( x11-libs/libXpm virtual/x11 ) )
	allegro? ( media-libs/allegro )
	opengl? ( virtual/glu )
	sdl? ( media-libs/libsdl )
	X? ( || ( x11-libs/libXext virtual/x11 ) )"
DEPEND="${RDEPEND}
	X? ( || ( x11-proto/xextproto virtual/x11 ) )"

S=${WORKDIR}/DevIL-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-png-types.patch
	epatch "${FILESDIR}"/${P}-sdl-checks.patch
	autoconf || die
}

src_compile() {
	econf \
		$(use_enable gif) \
		$(use_enable jpeg) \
		$(use_enable mng) \
		$(use_enable png) \
		$(use_enable tiff) \
		$(use_enable xpm) \
		$(use_enable allegro) \
		$(use_enable opengl) \
		$(use_enable sdl) \
		$(use_with X x) \
		--disable-directx \
		--disable-win32 \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS CREDITS ChangeLog* NEWS* README*
}
