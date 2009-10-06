# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/klinkstatus/klinkstatus-4.3.2.ebuild,v 1.1 2009/10/06 19:38:46 alexxy Exp $

EAPI="2"
KMNAME="kdewebdev"
inherit kde4-meta

DESCRIPTION="KDE web development - link validity checker"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook tidy"

DEPEND="
	>=kde-base/kdepimlibs-${PV}:${SLOT}[kdeprefix=]
	tidy? ( app-text/htmltidy )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DWITH_KdepimLibs=ON
		$(cmake-utils_use_with tidy LibTidy)"

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	echo
	elog "To use scripting in ${PN}, install dev-lang/ruby."
	echo
}
