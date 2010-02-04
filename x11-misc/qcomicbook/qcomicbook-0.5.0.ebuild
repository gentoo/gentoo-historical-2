# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/qcomicbook/qcomicbook-0.5.0.ebuild,v 1.4 2010/02/04 17:30:08 hwoarang Exp $

EAPI=2
CMAKE_IN_SOURCE_BUILD=1
inherit cmake-utils

DESCRIPTION="A viewer for comic book archives containing jpeg/png images."
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=19509"
SRC_URI="http://cloud.github.com/downloads/stolowski/QComicBook/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-gui:4"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog NEWS README THANKS"

pkg_postinst() {
	elog "For using QComicBook with compressed archives you may want to install:"
	elog "    app-arch/p7zip"
	elog "    app-arch/unace"
	elog "    app-arch/unrar or app-arch/rar"
	elog "    app-arch/unzip"
}
