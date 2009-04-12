# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/umbrello/umbrello-4.2.2.ebuild,v 1.1 2009/04/12 06:48:25 alexxy Exp $

EAPI="2"

KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="KDE: Umbrello UML Modeller"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug doc"

DEPEND="
	dev-libs/boost
	dev-libs/libxml2
	dev-libs/libxslt
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Disable hardcoded kdepimlibs check - only 4.2 branch is affected
	sed -i -e 's/find_package(KdepimLibs REQUIRED)/macro_optional_find_package(KdepimLibs)/' \
		CMakeLists.txt || die "failed to disable kdepimlibs hardcoded check"

	kde4-meta_src_prepare
}
