# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio/libcdio-0.66.ebuild,v 1.4 2004/06/24 23:14:15 agriffis Exp $

IUSE=""

DESCRIPTION="A library to encapsulate CD-ROM reading and control."
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64 ~ia64"


src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS
}
