# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/DFBPoint/DFBPoint-0.7.2.ebuild,v 1.8 2004/07/01 10:48:24 eradicator Exp $

S=${WORKDIR}/${P}
DESCRIPTION="DFBPoint is presentation program based on DirectFB"
SRC_URI="http://www.directfb.org/download/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.directfb.org/dfbpoint.xml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -sparc"

DEPEND="virtual/libc dev-libs/DirectFB"
RDEPEND="${DEPEND}"

src_install () {

	make DESTDIR=${D} install || die

	dodir /usr/share/DFBPoint/
	cp dfbpoint.dtd ${D}/usr/share/DFBPoint/

	dodoc AUTHORS COPYING ChangeLog INSTALL README NEWS

	dodir /usr/share/DFBPoint/examples/
	cd examples
	cp bg.png ${D}/usr/share/DFBPoint/examples/
	cp bullet.png ${D}/usr/share/DFBPoint/examples/
	cp decker.ttf ${D}/usr/share/DFBPoint/examples/
	cp test.xml ${D}/usr/share/DFBPoint/examples/
	cp wilber_stoned.png ${D}/usr/share/DFBPoint/examples/
	cp -R guadec/ ${D}/usr/share/DFBPoint/examples/
}
