# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sdl-gui/sdl-gui-0.10.3.ebuild,v 1.5 2007/05/04 05:50:12 mr_bones_ Exp $

inherit eutils

MY_P="SDL_gui-${PV}"
DESCRIPTION="Graphical User Interface library that utilizes SDL"
HOMEPAGE="http://rhk.dataslab.com/SDL_gui"
SRC_URI="http://rhk.dataslab.com/SDL_gui/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.1.4
	>=media-libs/sdl-image-1.0.9
	>=media-libs/sdl-ttf-1.2.1"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-gcc4.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README TODO
}
