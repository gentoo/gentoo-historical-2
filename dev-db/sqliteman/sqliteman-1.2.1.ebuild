# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqliteman/sqliteman-1.2.1.ebuild,v 1.4 2010/01/02 20:27:11 yngwin Exp $

EAPI=2

inherit eutils cmake-utils

DESCRIPTION="Powerful GUI manager for the Sqlite3 database"
HOMEPAGE="http://sqliteman.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4[sqlite]
	x11-libs/qscintilla"
DEPEND="${RDEPEND}"

DOCS="AUTHORS README"

src_prepare() {
	# remove bundled lib
	rm -rf "${S}"/${PN}/qscintilla2
}
