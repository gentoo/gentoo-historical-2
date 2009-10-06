# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/gwenview/gwenview-4.3.2.ebuild,v 1.1 2009/10/06 18:04:46 alexxy Exp $

EAPI="2"

KMNAME="kdegraphics"
inherit kde4-meta

DESCRIPTION="KDE image viewer"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook kipi +semantic-desktop"

# tests hang, last checked for 4.2.96
RESTRICT="test"

DEPEND="
	>=media-gfx/exiv2-0.18
	media-libs/jpeg
	kipi? ( >=kde-base/libkipi-${PV}:${SLOT}[kdeprefix=] )
	>=kde-base/kdelibs-${PV}:${SLOT}[kdeprefix=,semantic-desktop?]
"
RDEPEND="${DEPEND}
	semantic-desktop? ( >=kde-base/nepomuk-${PV}:${SLOT}[kdeprefix=] )
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with kipi)"

	if use semantic-desktop; then
		mycmakeargs="${mycmakeargs}
			-DGWENVIEW_SEMANTICINFO_BACKEND=Nepomuk"
	else
		mycmakeargs="${mycmakeargs}
			-DGWENVIEW_SEMANTICINFO_BACKEND=None"
	fi

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	echo
	elog "If you want to have svg support, emerge kde-base/svgpart"
	echo
}
