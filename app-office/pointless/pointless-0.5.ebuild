# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/pointless/pointless-0.5.ebuild,v 1.7 2005/01/01 15:40:34 eradicator Exp $

DESCRIPTION="A presentation tool using markup-language"
HOMEPAGE="http://www.pointless.dk/"
SRC_URI="mirror://sourceforge/pointless/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc"

IUSE="X doc sdl nls"

DEPEND="X? ( virtual/x11 )
	>=media-fonts/freefonts-0.10
	>=dev-lang/python-2.2.0
	>=media-libs/freetype-2.1.5
	sdl? ( >=media-libs/libsdl-1.2.6 )
	nls? ( >=sys-devel/gettext-0.12.1 )"


src_compile() {
	use doc		&& myconf="${myconf} --enable-html"
	use sdl		&& myconf="${myconf} --enable-sdl"
	use sdl		|| myconf="${myconf} --disable-sdltest"
	use nls		&& myconf="${myconf} --enable-nls"
	use X		&& myconf="${myconf} --with-x"

	econf ${myconf} || die

	emake || die
}

src_install() {
	dodoc README PLANS TODO NEWS AUTHORS BUGS
	einstall || die
}
