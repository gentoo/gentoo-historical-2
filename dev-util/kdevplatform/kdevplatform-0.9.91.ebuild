# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevplatform/kdevplatform-0.9.91.ebuild,v 1.2 2009/03/01 12:07:56 tampakrap Exp $

EAPI="2"

inherit kde4-base versionator

KDEVELOP_PV="`expr $(get_major_version) + 3`.$(get_after_major_version)"
echo ${KDEVELOP_PV}
DESCRIPTION="KDE development support libraries and apps"
HOMEPAGE="http://www.kde.org/"
SRC_URI="mirror://kde/unstable/kdevelop/${KDEVELOP_PV}/src/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="1"
IUSE="bazaar cvs debug git htmlhandbook mercurial subversion"

DEPEND="
	subversion? ( >=dev-util/subversion-1.3 )
"
RDEPEND="${DEPEND}
	bazaar? ( dev-util/bzr )
	cvs? ( dev-util/cvs )
	git? ( dev-util/git )
	mercurial? ( dev-util/mercurial )
"

src_configure() {
	mycmakeargs="${mycmakeargs}
		-DBUILD_bazaar=$(useq bazaar && echo ON || echo OFF)
		-DBUILD_cvs=$(useq cvs && echo ON || echo OFF)
		-DBUILD_git=$(useq git && echo ON || echo OFF)
		-DBUILD_mercurial=$(useq mercurial && echo ON || echo OFF)
		-DBUILD_subversion=$(useq subversion && echo ON || echo OFF)
		$(cmake-utils_use_with subversion SubversionLibrary)"

	kde4-base_src_configure
}
