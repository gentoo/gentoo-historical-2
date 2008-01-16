# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/DFBPoint/DFBPoint-0.7.2.ebuild,v 1.12 2008/01/16 19:25:08 armin76 Exp $

DESCRIPTION="DFBPoint is presentation program based on DirectFB"
HOMEPAGE="http://www.directfb.org/dfbpoint.xml"
SRC_URI="http://www.directfb.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -sparc x86"
IUSE=""

DEPEND="dev-util/pkgconfig
	dev-libs/DirectFB"

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	dodir /usr/share/DFBPoint/
	cp dfbpoint.dtd "${D}"/usr/share/DFBPoint/ || die "cp failed"

	dodoc AUTHORS ChangeLog INSTALL README NEWS

	dodir /usr/share/DFBPoint/examples/
	cd examples
	cp bg.png bullet.png decker.ttf test.xml wilber_stoned.png \
		"${D}"/usr/share/DFBPoint/examples/ || die "cp failed"
	cp -R guadec/ "${D}"/usr/share/DFBPoint/examples/ || die "cp failed"
}
