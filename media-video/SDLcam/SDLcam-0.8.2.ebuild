# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/SDLcam/SDLcam-0.8.2.ebuild,v 1.2 2009/08/08 20:44:56 vostorga Exp $

inherit eutils

DESCRIPTION="webcam application that uses the SDL library"
HOMEPAGE="http://sdlcam.raphnet.net/"
SRC_URI="http://sdlcam.raphnet.net/downloads/sdlcam-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-libs/libxml2
	media-libs/jpeg
	media-libs/libpng
	media-libs/libfame
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-ttf"

S=${WORKDIR}/sdlcam-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-glibc210.patch
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO \
		Documentation/config_file.txt Documentation/gui.txt
}
