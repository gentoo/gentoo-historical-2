# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdbusmenu-qt/libdbusmenu-qt-0.3.0.ebuild,v 1.2 2010/04/27 13:47:48 reavertm Exp $

EAPI=2

inherit cmake-utils

DESCRIPTION="Qt implementation of the DBusMenu protocol"
HOMEPAGE="http://people.canonical.com/~agateau/dbusmenu/"
SRC_URI="http://people.canonical.com/~agateau/dbusmenu/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Add "test" when the automatic/required dependency upon dev-libs/qjson is fixed!
IUSE=""

# Bug #315215, require X server running
RESTRICT="test"

# Change this to test?(qjson) when the automatic/required dep is fixed!
DEPEND="
	dev-libs/qjson
	x11-libs/qt-gui:4
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-set-link-directories.patch"
}
