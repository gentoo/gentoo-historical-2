# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/akonadi-server/akonadi-server-1.0.0.ebuild,v 1.2 2008/10/25 12:30:05 pvdabeel Exp $

EAPI="2"

inherit cmake-utils qt4

DESCRIPTION="The server part of Akonadi"
HOMEPAGE="http://pim.kde.org/akonadi"
SRC_URI="http://akonadi.omat.nl/${P/-server/}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mysql"

RDEPEND="!app-office/akonadi
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4
	x11-libs/qt-sql:4[sqlite]
	x11-libs/qt-test:4
	x11-misc/shared-mime-info
	mysql? ( virtual/mysql )"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	kde-base/automoc"

S="${WORKDIR}/${P/-server/}"

src_unpack() {
	unpack ${A}

	# Don't check for mysql, avoid an automagic dep.
	if ! use mysql; then
		sed -e '/mysqld/s/find_program/#DONOTWANT &/' \
			-i "${S}"/server/CMakeLists.txt || die 'Sed failed.'
	fi
}
