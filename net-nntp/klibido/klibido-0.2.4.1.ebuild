# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nntp/klibido/klibido-0.2.4.1.ebuild,v 1.2 2005/11/17 08:50:46 flameeyes Exp $

inherit kde versionator

DESCRIPTION="KDE Linux Binaries Downloader"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://klibido.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="debug"

RDEPEND=">=sys-libs/db-4.1"
DEPEND="${RDEPEND}
	dev-libs/uulib"

need-kde 3

src_compile() {
	local libdbver="$(best_version sys-libs/db)"
	libdbver="${libdbver/sys-libs\/db-/}"
	libdbver="$(get_version_component_range 1-2 ${libdbver})"

	myconf="${myconf}
		--with-extra-includes=/usr/include/db${libdbver}/
		$(use_enable debug)
	"
	kde_src_compile
}
