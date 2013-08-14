# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/gwenview/gwenview-4.11.0.ebuild,v 1.1 2013/08/14 20:23:45 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE image viewer"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug kipi"

# tests hang, last checked for 4.2.96
RESTRICT="test"

DEPEND="
	$(add_kdebase_dep libkonq)
	$(add_kdebase_dep kactivities)
	>=media-gfx/exiv2-0.19
	media-libs/lcms:2
	media-libs/libpng:0=
	virtual/jpeg:0
	x11-libs/libX11
	kipi? ( $(add_kdebase_dep libkipi) )
"
RDEPEND="${DEPEND}"

KMLOADLIBS="libkonq"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with kipi)
	)

	# Workaround for bug #479510
	if [[ -e ${EPREFIX}/usr/include/${CHOST}/jconfig.h ]]; then
		mycmakeargs+=( -DJCONFIG_H="${EPREFIX}/usr/include/${CHOST}/jconfig.h" )
	fi

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! has_version kde-base/svgpart:${SLOT} ; then
		elog "For SVG support, install kde-base/svgpart:${SLOT}"
	fi

	if use kipi && ! has_version media-plugins/kipi-plugins ; then
		elog "The plugins for the KIPI inteface can be found in media-plugins/kipi-plugins"
	fi
}
