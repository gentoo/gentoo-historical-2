# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rol/rol-0.2.2.ebuild,v 1.13 2004/12/16 01:47:53 ticho Exp $

DESCRIPTION="A RSS/RDF Newsreader"
HOMEPAGE="http://unknown-days.com/rol/"
SRC_URI="http://unknown-days.com/rol/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~amd64 ~ppc ~sparc alpha ~hppa"
IUSE=""


DEPEND="virtual/x11
	dev-libs/libxml
	>=x11-libs/gtk+-2.0.9
	>=gnome-base/gconf-2"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s:-DGTK_DISABLE_DEPRECATED ::" src/Makefile
}

src_compile() {
	emake || die
}

src_install() {
	cd ${S}/src
	dobin rol
	cd ${S}
	dodoc AUTHORS ChangeLog README SITES
}
