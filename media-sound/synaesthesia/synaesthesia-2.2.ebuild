# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/synaesthesia/synaesthesia-2.2.ebuild,v 1.6 2005/04/27 07:55:56 eradicator Exp $

DESCRIPTION="a nice graphical accompaniment to music"
HOMEPAGE="http://www.logarithmic.net/pfh/synaesthesia"
SRC_URI="http://www.logarithmic.net/pfh-files/synaesthesia/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="sdl svga esd"

DEPEND="virtual/x11
	esd? ( >=media-sound/esound-0.2.22 )
	sdl? ( >=media-libs/libsdl-1.2.0 )
	svga? ( >=media-libs/svgalib-1.4.3 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i \
		-e "/CFLAGS=/s:-O4:${CFLAGS}:" \
		-e "/CXXFLAGS=/s:-O4:${CXXFLAGS}:" \
		configure
	sed -i 's:void inline:inline void:' syna.h
}

src_install() {
	dobin synaesthesia || die
	dodoc README
}
