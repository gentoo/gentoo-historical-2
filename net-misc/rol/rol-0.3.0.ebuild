# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rol/rol-0.3.0.ebuild,v 1.3 2004/06/25 00:09:06 agriffis Exp $

DESCRIPTION="A RSS/RDF Newsreader"
HOMEPAGE="http://unknown-days.com/rol/"
SRC_URI="http://unknown-days.com/rol/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~alpha ~hppa"
IUSE=""

DEPEND="virtual/x11
	dev-libs/libxml
	>=x11-libs/gtk+-2.0.9
	=dev-cpp/gtkmm-2.2.11
	>=gnome-base/gconf-2"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dodoc ChangeLog README SITES
	doman rol.1
	cd src
	dobin rol || die "dobin failed"
}
