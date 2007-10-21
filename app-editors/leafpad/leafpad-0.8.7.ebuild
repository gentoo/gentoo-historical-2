# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/leafpad/leafpad-0.8.7.ebuild,v 1.2 2007/10/21 16:32:12 maekke Exp $

inherit eutils

DESCRIPTION="Simple gtk+ text editor"
HOMEPAGE="http://tarot.freeshell.org/leafpad/"
SRC_URI="http://savannah.nongnu.org/download/leafpad/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4"
DEPEND="${RDEPEND} dev-util/pkgconfig"

src_compile() {
	econf --enable-chooser
	emake
}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog NEWS README
}
