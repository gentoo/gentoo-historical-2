# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/parley/parley-4.10.4.ebuild,v 1.4 2013/07/01 09:08:00 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE Educational: vocabulary trainer"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
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
