# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio/libcdio-0.64.ebuild,v 1.11 2004/09/15 17:29:59 eradicator Exp $

IUSE=""

DESCRIPTION="A library to encapsulate CD-ROM reading and control."
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ppc sparc alpha amd64 ia64"


src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING Changelog INSTALL NEWS README THANKS
}
