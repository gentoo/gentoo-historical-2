# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop/kdevelop-3.9.91.ebuild,v 1.2 2009/03/01 12:10:39 tampakrap Exp $

EAPI="2"

inherit kde4-base versionator

KDEVPLATFORM_P="kdevplatform-`expr $(get_major_version) - 3`.$(get_after_major_version)"
DESCRIPTION="Integrated Development Environment for Unix, supporting KDE/Qt, C/C++ and many other languages."
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="+cmake +cxx debug +qmake"

DEPEND="
	>=dev-util/${KDEVPLATFORM_P}[kdeprefix=]
"
RDEPEND="${DEPEND}
	>=kde-base/kapptemplate-${KDE_MINIMAL}[kdeprefix=]
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DBUILD_cmake=$(useq cmake && echo On || echo Off)
		-DBUILD_cmakebuilder=$(useq cmake && echo On || echo Off)
		-DBUILD_qmake=$(useq qmake && echo On || echo Off)
		-DBUILD_qmakebuilder=$(useq qmake && echo On || echo Off)
		-DBUILD_cpp=$(useq cxx && echo On || echo Off)"

	kde4-base_src_configure
}
