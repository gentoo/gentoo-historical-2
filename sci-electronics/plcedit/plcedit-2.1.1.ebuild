# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/plcedit/plcedit-2.1.1.ebuild,v 1.3 2010/03/09 12:21:47 abcd Exp $

EAPI="2"

inherit versionator qt4-r2
MY_PN="PLCEdit"

DESCRIPTION="Qt4 notepad for PLC programming"
HOMEPAGE="http://www.qt-apps.org/content/show.php/PLCEdit?content=78380"
#upstreams default tarball is quite messy. Better repack it myself :/
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"

src_install(){
	newbin release/${MY_PN} ${PN} || die "dobin failed"
	newicon src/ressources/images/icon.png ${PN}.png
	make_desktop_entry ${PN} ${MY_PN} ${PN} 'Qt;Electronics'
	dodoc readme.txt || die "dodoc failed"
	if use doc; then
		dohtml -r Docs/html/* || die "dohtml failed"
	fi
}
