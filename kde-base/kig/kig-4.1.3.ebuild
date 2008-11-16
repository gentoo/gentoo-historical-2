# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kig/kig-4.1.3.ebuild,v 1.2 2008/11/16 07:36:08 vapier Exp $

EAPI="2"

KMNAME=kdeedu
inherit kde4-meta

DESCRIPTION="KDE Interactive Geometry tool"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug htmlhandbook kig-scripting"

DEPEND="kig-scripting? ( >=dev-libs/boost-1.32 )"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with kig-scripting BoostPython)"

	kde4-meta_src_configure
}
