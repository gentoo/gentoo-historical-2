# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/abby/abby-0.4.8.ebuild,v 1.1 2010/04/12 10:21:33 aballier Exp $

EAPI="1"
inherit qt4

DESCRIPTION="GUI front-end for cclive and clive video extraction utilities"
HOMEPAGE="http://code.google.com/p/abby/"
SRC_URI="http://abby.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="|| ( >=media-video/clive-2.2.5 >=media-video/cclive-0.5.0 )
	x11-libs/qt-gui:4"
DEPEND="${RDEPEND}"

src_compile() {
	eqmake4 || die
	emake || die
}

src_install() {
	dobin abby || die
	dodoc AUTHORS ChangeLog README TODO NEWS
}
