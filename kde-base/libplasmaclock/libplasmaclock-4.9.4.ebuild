# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libplasmaclock/libplasmaclock-4.9.4.ebuild,v 1.1 2012/12/05 16:58:09 alexxy Exp $

EAPI=4

KMNAME="kde-workspace"
KMMODULE="libs/plasmaclock"
inherit kde4-meta

DESCRIPTION="Libraries for KDE Plasma's clocks"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +holidays"

DEPEND="
	$(add_kdebase_dep kephal)
	holidays? ( $(add_kdebase_dep kdepimlibs) )
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

KMEXTRACTONLY="
	libs/kephal/
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with holidays KdepimLibs)
	)

	kde4-meta_src_configure
}
