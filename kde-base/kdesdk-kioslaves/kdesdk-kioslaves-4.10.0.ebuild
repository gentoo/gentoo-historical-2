# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kioslaves/kdesdk-kioslaves-4.10.0.ebuild,v 1.1 2013/02/07 04:57:35 alexxy Exp $

EAPI=5

KMNAME="kdesdk"
KMMODULE="kioslave"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="kioslaves from kdesdk package"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug subversion"

DEPEND="
	subversion? (
		dev-libs/apr
		dev-vcs/subversion
	)
"
RDEPEND="${DEPEND}
	subversion? ( !>=dev-vcs/kdesvn-1.5.2:4 )
"

src_configure() {
	mycmakeargs=(
		-DAPRCONFIG_EXECUTABLE="${EPREFIX}"/usr/bin/apr-1-config
		$(cmake-utils_use_with subversion SVN)
	)

	kde4-meta_src_configure
}
