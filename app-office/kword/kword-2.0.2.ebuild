# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kword/kword-2.0.2.ebuild,v 1.2 2009/10/01 15:23:06 scarabeus Exp $

EAPI="2"

KMNAME="koffice"
KMMODULE="${PN}"
inherit kde4-meta

DESCRIPTION="KOffice word processor."

KEYWORDS="~amd64 ~x86"
IUSE="+wpd +wv2"

DEPEND="
	wpd? ( app-text/libwpd )
	wv2? ( =app-text/wv2-0.3* )
"
RDEPEND="${DEPEND}"

KMEXTRA="filters/${KMMODULE}/"

KMEXTRACTONLY="
	filters/
	kspread/
	libs/
	plugins/
"

KMLOADLIBS="koffice-libs"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with wpd WPD)
		$(cmake-utils_use_with wv2 WV2)"

	kde4-meta_src_configure
}
