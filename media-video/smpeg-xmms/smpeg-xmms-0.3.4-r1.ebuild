# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/smpeg-xmms/smpeg-xmms-0.3.4-r1.ebuild,v 1.5 2002/10/04 05:57:04 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A MPEG Plugin for XMMS"
SRC_URI="ftp://ftp.xmms.org/xmms/plugins/smpeg-xmms/${P}.tar.gz"
HOMEPAGE="http://www.xmms.org/plugins_input.html"

DEPEND=">=media-sound/xmms-1.2.3
	>=media-libs/smpeg-0.4.4-r1
	sdl? ( >=media-libs/libsdl-1.2.2 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile() {

	cd ${S}
	local myconf
	use sdl || myconf="${myconf} --disable-sdltest"
	
	econf ${myconf} || die
	make || die

}

src_install () {

	cd ${S}
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING README TODO ChangeLog
}
