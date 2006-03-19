# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/videorbits/videorbits-2.201.ebuild,v 1.10 2006/03/19 00:08:49 joshuabaergen Exp $

DESCRIPTION="a collection of programs for creating high dynamic range images"
HOMEPAGE="http://comparametric.sourceforge.net/"
SRC_URI="mirror://sourceforge/comparametric/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

DEPEND="virtual/libc
	|| ( x11-libs/libX11 virtual/x11 )
	sys-libs/zlib
	media-libs/libpng
	media-libs/jpeg"

src_unpack() {
	unpack ${A}

	cd ${S}/images
	mv Makefile.in Makefile.in-orig
	sed -e "s:\$(prefix)/images:\$(prefix)/share/${PN}/images:" Makefile.in-orig > Makefile.in

	cd ${S}/lookuptables
	mv Makefile.in Makefile.in-orig
	sed -e "s:\$(prefix)/lookuptables:\$(prefix)/share/${PN}/lookuptables:" Makefile.in-orig > Makefile.in
}

src_compile() {
	econf || die "./configure failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING NEWS README README.MORE
}
