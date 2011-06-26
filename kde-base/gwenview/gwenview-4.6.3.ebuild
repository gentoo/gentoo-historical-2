# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/gwenview/gwenview-4.6.3.ebuild,v 1.4 2011/06/26 01:54:33 ranger Exp $

EAPI=4

KDE_HANDBOOK="optional"
if [[ ${PV} == *9999 ]]; then
KDE_SCM="git"
kde_eclass="kde4-base"
else
KMNAME="kdegraphics"
kde_eclass="kde4-meta"
fi
inherit ${kde_eclass}

DESCRIPTION="KDE image viewer"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug kipi semantic-desktop"

# tests hang, last checked for 4.2.96
RESTRICT="test"

DEPEND="
	$(add_kdebase_dep kdelibs 'semantic-desktop=')
	>=media-gfx/exiv2-0.18
	virtual/jpeg
	kipi? ( $(add_kdebase_dep libkipi) )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with semantic-desktop Soprano)
		$(cmake-utils_use_with kipi)
	)

	if use semantic-desktop; then
		mycmakeargs+=(-DGWENVIEW_SEMANTICINFO_BACKEND=Nepomuk)
	else
		mycmakeargs+=(-DGWENVIEW_SEMANTICINFO_BACKEND=None)
	fi

	${kde_eclass}_src_configure
}

pkg_postinst() {
	${kde_eclass}_pkg_postinst

	echo
	elog "For SVG support, emerge -va kde-base/svgpart"
	echo
}
