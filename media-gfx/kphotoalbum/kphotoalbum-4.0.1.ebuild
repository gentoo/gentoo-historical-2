# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kphotoalbum/kphotoalbum-4.0.1.ebuild,v 1.1 2009/05/28 19:44:22 scarabeus Exp $

EAPI="2"

inherit kde4-base

DESCRIPTION="KDE Photo Album is a tool for indexing, searching, and viewing images."
HOMEPAGE="http://www.kphotoalbum.org/"
SRC_URI="http://www.${PN}.org/data/download/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug +exif +geolocation +kipi +raw +semantic-desktop"

DEPEND="
	>=kde-base/kdelibs-${KDE_MINIMAL}[semantic-desktop?]
	media-libs/jpeg
	>=x11-libs/qt-sql-4.4:4[sqlite]
	exif? ( >=media-gfx/exiv2-0.17 )
	geolocation? ( >=kde-base/marble-${KDE_MINIMAL} )
	kipi? ( >=kde-base/libkipi-${KDE_MINIMAL} )
	raw? ( >=kde-base/libkdcraw-${KDE_MINIMAL} )
"
RDEPEND="${DEPEND}
	!${CATEGORY}/${PN}:0
	semantic-desktop? ( >=kde-base/nepomuk-${KDE_MINIMAL} )
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with exif Exiv2)
		$(cmake-utils_use_with raw Kdcraw)
		$(cmake-utils_use_with kipi Kipi)
		$(cmake-utils_use_with geolocation Marble)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)"

	kde4-base_src_configure
}
