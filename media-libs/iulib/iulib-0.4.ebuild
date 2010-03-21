# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/iulib/iulib-0.4.ebuild,v 1.4 2010/03/21 05:03:55 vapier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="easy-to-use image and video I/O functions"
HOMEPAGE="http://code.google.com/p/iulib/"
SRC_URI="http://iulib.googlecode.com/files/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sdl"

DEPEND="sys-libs/zlib
	dev-util/scons
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	sdl? (
		media-libs/libsdl
		media-libs/sdl-gfx
	)"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.4-scons-build-env.patch
	sed -i \
		-e "/^have_sdl = 1/s:1:`use sdl && echo 1 || echo 0`:" \
		-e '/tiff/s:inflate:TIFFOpen:' \
		-e '/progs.Append(LIBS=libiulib)/s:Append:Prepend:' \
		SConstruct || die #297326 #308955 #310439
	sed -i '/SDL.SDL_image.h/d' utils/dgraphics.cc || die #310443
}

src_compile() {
	tc-export CC CXX
	scons prefix=/usr || die
}

src_install() {
	scons install prefix="${D}/usr" || die
	dodoc CHANGES README TODO
}
