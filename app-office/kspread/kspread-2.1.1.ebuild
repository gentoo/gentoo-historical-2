# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kspread/kspread-2.1.1.ebuild,v 1.2 2010/06/21 13:58:21 ssuominen Exp $

EAPI="2"

KMNAME="koffice"
KMMODULE="${PN}"
inherit kde4-meta

DESCRIPTION="KOffice spreadsheet application."

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="solver"

DEPEND="
	dev-cpp/eigen:2
	solver? ( sci-libs/gsl )
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	kchart/
	interfaces/
	libs/
	filters/
	plugins/
"
KMEXTRA="filters/${KMMODULE}/"

KMLOADLIBS="koffice-libs"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWITH_Eigen2=ON
		$(cmake-utils_use_with solver GSL)"

	kde4-meta_src_configure
}
