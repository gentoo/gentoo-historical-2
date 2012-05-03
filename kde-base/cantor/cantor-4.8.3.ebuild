# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/cantor/cantor-4.8.3.ebuild,v 1.1 2012/05/03 20:08:10 johu Exp $

EAPI=4

KDE_HANDBOOK="optional"
KDE_SCM="git"
inherit kde4-base

DESCRIPTION="KDE4 interface for doing mathematics and scientific computing"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="analitza debug ps +R"

# TODO Add Sage Mathematics Software backend (http://www.sagemath.org)
RDEPEND="
	analitza? ( $(add_kdebase_dep analitza) )
	ps? ( app-text/libspectre )
	R? ( dev-lang/R )
"
DEPEND="${RDEPEND}
	>=dev-cpp/eigen-2.0.3:2
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with analitza)
		$(cmake-utils_use_with ps LibSpectre)
		$(cmake-utils_use_with R)
	)
	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! use R; then
		echo
		ewarn "You have decided to build ${PN} with no backend."
		ewarn "To have this application functional, please do one of below:"
		ewarn "    # emerge -va1 '='${CATEGORY}/${P} with 'R' USE flag enabled"
		ewarn "    # emerge -vaDu sci-mathematics/maxima"
		echo
	fi
}
