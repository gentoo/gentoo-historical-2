# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/oneclickftp/oneclickftp-0.5.1.ebuild,v 1.1 2009/12/15 09:10:25 ssuominen Exp $

EAPI=2
inherit eutils qt4

DESCRIPTION="The somehow different FTP client"
HOMEPAGE="http://oneclickftp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-crypt/qca-2
	x11-libs/qt-gui:4"

src_configure() {
	eqmake4
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die
	doicon res/icons/${PN}.png
	make_desktop_entry ${PN} ${PN}
	dodoc CHANGELOG
}
