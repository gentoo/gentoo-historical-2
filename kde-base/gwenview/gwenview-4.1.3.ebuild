# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/gwenview/gwenview-4.1.3.ebuild,v 1.1 2008/11/09 01:38:15 scarabeus Exp $

EAPI="2"

KMNAME=kdegraphics
inherit kde4-meta

DESCRIPTION="KDE image viewer"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook kipi +semantic-desktop"

DEPEND="
	media-gfx/exiv2
	media-libs/jpeg
	kipi? ( kde-base/libkipi:${SLOT} )
	semantic-desktop? ( kde-base/nepomuk:${SLOT} )"

RDEPEND="${DEPEND}"

# Tests are broken (4.1.0)
RESTRICT="test"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with kipi KIPI)"
	if use semantic-desktop; then
		mycmakeargs="${mycmakeargs}
			-DGWENVIEW_METADATA_BACKEND=Nepomuk"
	else
		mycmakeargs="${mycmakeargs}
			-DGWENVIEW_METADATA_BACKEND=None"
	fi

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst
	echo
	elog "If you want to have svg support, emerge kde-base/svgpart"
	echo
}
