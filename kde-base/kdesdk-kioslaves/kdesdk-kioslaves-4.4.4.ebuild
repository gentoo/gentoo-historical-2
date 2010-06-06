# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kioslaves/kdesdk-kioslaves-4.4.4.ebuild,v 1.1 2010/06/06 14:41:58 scarabeus Exp $

EAPI="3"

KMNAME="kdesdk"
KMMODULE="kioslave"
inherit kde4-meta

DESCRIPTION="kioslaves from kdesdk package"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug subversion"

DEPEND="
	subversion? (
		dev-libs/apr
		dev-util/subversion
	)
"
RDEPEND="${DEPEND}
	!kdeprefix? (
		subversion? ( !>=dev-vcs/kdesvn-1.5.2:4 )
	)
"

src_configure() {
	mycmakeargs=(
		-DAPRCONFIG_EXECUTABLE="${EPREFIX}"/usr/bin/apr-1-config
		$(cmake-utils_use_with subversion SVN)
	)

	kde4-meta_src_configure
}
