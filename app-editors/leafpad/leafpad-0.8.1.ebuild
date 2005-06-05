# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/leafpad/leafpad-0.8.1.ebuild,v 1.1 2005/06/05 21:08:30 taviso Exp $

inherit eutils

DESCRIPTION="simple gtk+ text editor"
HOMEPAGE="http://tarot.freeshell.org/leafpad/"
SRC_URI="http://savannah.nongnu.org/download/leafpad/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2.4"
DEPEND="${RDEPEND} dev-util/pkgconfig"

src_compile() {
	econf --disable-rpath --enable-chooser `use_enable nls`
	emake
}

src_install() {
	einstall
	dodoc AUTHORS ChangeLog COPYING NEWS README
}
