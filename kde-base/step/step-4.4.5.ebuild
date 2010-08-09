# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/step/step-4.4.5.ebuild,v 1.4 2010/08/09 10:19:10 fauli Exp $

EAPI="3"

KMNAME="kdeedu"
inherit kde4-meta

DESCRIPTION="The KDE physics simulator"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook +gsl +qalculate"

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
