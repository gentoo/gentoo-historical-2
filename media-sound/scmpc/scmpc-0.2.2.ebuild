# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/scmpc/scmpc-0.2.2.ebuild,v 1.2 2007/06/28 17:35:38 armin76 Exp $

DESCRIPTION="a client for MPD which submits your tracks to last.fm"
HOMEPAGE="http://scmpc.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/curl
	dev-libs/argtable
	dev-libs/confuse
	dev-libs/libdaemon"

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	newinitd "${FILESDIR}/scmpc.init" ${PN}
}
