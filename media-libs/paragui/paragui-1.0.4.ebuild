# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/paragui/paragui-1.0.4.ebuild,v 1.9 2007/11/11 21:54:42 tupone Exp $

inherit eutils

DESCRIPTION="A cross-platform high-level application framework and GUI library"
HOMEPAGE="http://www.paragui.org/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.4
	>=media-libs/sdl-image-1.2.1-r1
	dev-libs/expat
	dev-games/physfs"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-1.1.8-header.patch
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS README* RELEASENOTES.final TODO THANKS
}
