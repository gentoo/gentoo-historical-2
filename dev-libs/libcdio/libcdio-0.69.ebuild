# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio/libcdio-0.69.ebuild,v 1.1 2004/06/27 09:52:39 mholzer Exp $

IUSE="cddb"

DESCRIPTION="A library to encapsulate CD-ROM reading and control."
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
DEPEND="dev-util/pkgconfig
	dev-libs/popt
	cddb? ( >=media-libs/libcddb-0.9.4 )"


src_compile() {
	econf $(use_enable cddb) || die
	make || die # had problem with parallel make (phosphan@gentoo.org)
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS
}
