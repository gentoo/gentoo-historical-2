# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kget/kget-4.3.3-r1.ebuild,v 1.1 2010/05/14 15:49:06 reavertm Exp $

EAPI="2"

KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="An advanced download manager for KDE"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +handbook +plasma +semantic-desktop sqlite"

DEPEND="
	app-crypt/qca:2
	dev-libs/gmp
	dev-libs/libpcre
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
	$(add_kdebase_dep libkonq)
	$(add_kdebase_dep libkworkspace)
	sqlite? ( dev-db/sqlite:3 )
"
RDEPEND="${DEPEND}
	semantic-desktop? ( $(add_kdebase_dep nepomuk) )
"

PATCHES=(
	"${FILESDIR}/${PN}-4.3.5_CVE-2010-1000.patch"
)

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DENABLE_EMBEDDED_TORRENT_SUPPORT=ON -DWITH_KdeWebKit=OFF -DWITH_WebKitPart=OFF
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with sqlite)"

	kde4-meta_src_configure
}
