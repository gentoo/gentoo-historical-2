# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio/libcdio-0.63.ebuild,v 1.1 2003/10/10 15:34:53 mholzer Exp $

IUSE=""

DESCRIPTION="A library to encapsulate CD-ROM reading and control."
HOMEPAGE="http://savannah.nongnu.org/projects/libcdio/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${PN}.pkg/${PV}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"


src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING Changelog INSTALL NEWS README THANKS
}
