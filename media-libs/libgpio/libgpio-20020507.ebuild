# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/libgpio/libgpio-20020507.ebuild,v 1.2 2002/07/22 15:18:32 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="libgpio"
SRC_URI="http://www.ibiblio.org/gentoo/${P}.tar.bz2"
HOMEPAGE="http://www.gphoto.org"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86"

DEPEND="dev-libs/libusb 
	sys-devel/automake 
	sys-devel/autoconf 
	sys-devel/libtool"

RDEPEND="dev-libs/libusb"

src_compile() {

	./autogen.sh --prefix=/usr --host=${CHOST} || die
	make || die

}

src_install () {

	make DESTDIR=${D} install || die

}
