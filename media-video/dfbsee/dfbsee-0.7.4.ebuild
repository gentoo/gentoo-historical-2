# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dfbsee/dfbsee-0.7.4.ebuild,v 1.4 2005/10/30 23:13:44 flameeyes Exp $

inherit flag-o-matic

MY_PN="DFBSee"
MY_P=${MY_PN}-${PV}

DESCRIPTION="DFBSee is image viewer and video player based on DirectFB"
SRC_URI="http://www.directfb.org/download/${MY_P}.tar.gz"
HOMEPAGE="http://www.directfb.org/dfbsee.xml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 -sparc ~amd64"
IUSE=""

DEPEND="dev-libs/DirectFB
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_compile() {
	append-ldflags -Wl,-z,now

	econf || die "./configure failed"
	emake || die "make failed"
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README AUTHORS

}
