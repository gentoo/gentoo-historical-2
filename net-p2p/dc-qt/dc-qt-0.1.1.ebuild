# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/dc-qt/dc-qt-0.1.1.ebuild,v 1.1 2004/08/08 02:52:49 squinky86 Exp $

IUSE=""

DESCRIPTION="Direct Connect Text Client, QT Gui"
HOMEPAGE="http://dc-qt.sourceforge.net/"
SRC_URI="mirror://sourceforge/dc-qt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=x11-libs/qt-3.2
	>=net-p2p/dctc-0.85.9
	>=media-libs/xine-lib-1_rc5"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
