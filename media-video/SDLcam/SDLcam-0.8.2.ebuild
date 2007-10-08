# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/SDLcam/SDLcam-0.8.2.ebuild,v 1.1 2007/10/08 18:10:18 vapier Exp $

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

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO \
		Documentation/config_file.txt Documentation/gui.txt
}
