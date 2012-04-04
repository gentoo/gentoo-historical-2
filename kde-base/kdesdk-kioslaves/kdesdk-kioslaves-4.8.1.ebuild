# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kioslaves/kdesdk-kioslaves-4.8.1.ebuild,v 1.2 2012/04/04 17:59:30 ago Exp $

EAPI=4

KMNAME="kdesdk"
KMMODULE="kioslave"
inherit kde4-meta

DESCRIPTION="kioslaves from kdesdk package"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
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
