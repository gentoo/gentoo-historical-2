# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libextractor/libextractor-0.3.3.ebuild,v 1.3 2005/02/28 05:01:33 squinky86 Exp $

inherit libtool

IUSE="oggvorbis static"
DESCRIPTION="A simple library for keyword extraction"
HOMEPAGE="http://www.ovmj.org/~samanta/libextractor"
SRC_URI="http://www.ovmj.org/~samanta/libextractor/download/${P}.tar.bz2"
SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~sparc ~amd64 ~ppc"
DEPEND=">=sys-devel/libtool-1.4.1
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"

src_compile() {
	elibtoolize

	myconf="--with-gnu-ld"
	use static \
		&& myconf="${myconf} --enable-static" \
		|| myconf="${myconf} --disable-static"
	econf ${myconf} || die "econf failed"
	make || die "compile failed"
}

src_install () {
	make DESTDIR=${D} install || die "install failed"
}
