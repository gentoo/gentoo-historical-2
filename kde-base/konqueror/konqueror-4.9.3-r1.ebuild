# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konqueror/konqueror-4.9.3-r1.ebuild,v 1.1 2012/11/11 16:48:02 kensington Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
inherit flag-o-matic kde4-meta

DESCRIPTION="KDE: Web browser, file manager, ..."
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="+bookmarks debug svg"
# 4 of 4 tests fail. Last checked for 4.0.3
RESTRICT="test"

DEPEND="
	$(add_kdebase_dep libkonq)
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kfind)
	$(add_kdebase_dep kfmclient)
	bookmarks? ( $(add_kdebase_dep keditbookmarks) )
	svg? ( $(add_kdebase_dep svgpart) )
"

KMEXTRACTONLY="
	konqueror/client/
	lib/konq/
"

PATCHES=( "${FILESDIR}/${P}-crash.patch" )

src_prepare() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lmalloc

	kde4-meta_src_prepare

	# Do not install *.desktop files for kfmclient
	sed -e "/kfmclient\.desktop/d" -i konqueror/CMakeLists.txt \
		|| die "Failed to omit .desktop files"
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	echo
	elog "If you want to use konqueror as a filemanager, install the dolphin kpart:"
	elog "emerge -1 kde-base/dolphin:${SLOT}"
	elog
	elog "To use Java on webpages: emerge jre"
	echo
}
