# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/giblib/giblib-1.2.3.ebuild,v 1.7 2004/07/14 19:36:50 agriffis Exp $

inherit gcc

DESCRIPTION="Giblib, graphics library"
HOMEPAGE="http://www.linuxbrit.co.uk/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="as-is | BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc ~alpha ~amd64"
IUSE=""

DEPEND=">=media-libs/imlib2-1.0.3
	>=media-libs/freetype-2.0"

pkg_setup() {
	cd ${T}
	$(gcc-getCC) ${FILESDIR}/imlib-x-test.c `imlib2-config --libs` `imlib2-config --cflags` \
		|| die "You need to re-emerge Imlib2 with USE=X"
}

src_install() {
	make prefix=${D}/usr install || die
	rm -rf ${D}/usr/doc
	dodoc README AUTHORS ChangeLog
}
