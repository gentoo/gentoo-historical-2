# Copyriht 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-sound/sdl-sound-0.1.5.ebuild,v 1.3 2002/07/23 00:49:50 seemant Exp $

MY_P="${P/sdl-/SDL_}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="A library that handles the decoding sound file formats"
SRC_URI="http://icculus.org/SDL_sound/downloads/${MY_P}.tar.gz"
HOMEPAGE="http://icculus.org/SDL_sound/"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86"

DEPEND=">=media-libs/libsdl-1.2.4
	>=media-libs/smpeg-0.4.4-r1
	>=media-libs/libmikmod-3.1.9
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"

src_compile() {

	econf \
		--enable-midi \
		--disable-flac || die
		
	emake || die
}

src_install() {

	einstall || die
	
	dodoc CHANGELOG COPYING CREDITS INSTALL README TODO
}
