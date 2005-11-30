# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libuta/libuta-0.4.4.ebuild,v 1.1.1.1 2005/11/30 10:04:06 chriswhite Exp $

inherit flag-o-matic

IUSE=""
DESCRIPTION="a GUI library for C++ that uses SDL as its output layer"
SRC_URI="mirror://sourceforge/libuta/${P}.tar.gz"
HOMEPAGE="http://libuta.sourceforge.net/"

SLOT="0"
LICENSE="LGPL-2.1 GPL-2"
KEYWORDS="x86 -sparc"

DEPEND="media-libs/libsdl
	media-libs/libpng
	sys-libs/zlib
	=media-libs/freetype-1.3*
	=dev-libs/libsigc++-1.0*"

src_compile() {
	append-flags -fpermissive
	econf || die "configuration failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die
}
