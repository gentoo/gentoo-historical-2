# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kget/kget-4.5.1.ebuild,v 1.2 2010/09/06 04:51:01 reavertm Exp $

EAPI="3"

KDE_HANDBOOK=1
KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="An advanced download manager for KDE"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma semantic-desktop sqlite"

RDEPEND="
	app-crypt/qca:2
	dev-libs/gmp
	dev-libs/libpcre
	$(add_kdebase_dep kdelibs 'semantic-desktop?')
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep libkonq)
	$(add_kdebase_dep libkworkspace)
	sqlite? ( dev-db/sqlite:3 )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

src_prepare() {
	kde4-meta_src_prepare

	# Don't use external libbtcore, it's not really ready yet
	sed -e 's:find_package(BTCore):macro_optional_&:' \
		-i kget/transfer-plugins/bittorrent/CMakeLists.txt || die "sed failed"
}

src_configure() {
	mycmakeargs=(
		-DWITH_BTCore=OFF
		$(cmake-utils_use_with plasma)
		$(cmake-utils_use_with semantic-desktop Nepomuk)
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with sqlite)
	)

	kde4-meta_src_configure
}
