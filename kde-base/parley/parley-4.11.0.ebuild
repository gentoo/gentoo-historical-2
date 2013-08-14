# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/parley/parley-4.11.0.ebuild,v 1.1 2013/08/14 20:23:35 dilfridge Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Educational: vocabulary trainer"
HOMEPAGE="http://kde.org/applications/education/parley
http://edu.kde.org/applications/school/parley"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +plasma"

DEPEND="
	$(add_kdebase_dep libkdeedu)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkdeedu/keduvocdocument
"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with plasma)
	)

	kde4-base_src_configure
}
