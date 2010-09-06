# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/step/step-4.5.1.ebuild,v 1.2 2010/09/06 04:51:16 reavertm Exp $

EAPI="3"

KDE_HANDBOOK=1
KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="The KDE physics simulator"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +gsl +qalculate"

DEPEND="
	>=dev-cpp/eigen-2.0.3:2
	sci-libs/cln
	>=sci-mathematics/gmm-3.0
	gsl? ( >=sci-libs/gsl-1.9-r1 )
	qalculate? ( >=sci-libs/libqalculate-0.9.5 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.2-solaris.patch
)

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with gsl)
		$(cmake-utils_use_with qalculate)
	)

	kde4-meta_src_configure
}
