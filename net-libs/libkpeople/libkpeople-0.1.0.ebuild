# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libkpeople/libkpeople-0.1.0.ebuild,v 1.1 2013/10/29 19:04:09 johu Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
KDE_LINGUAS="cs da de hu nl pt pt_BR sk sv uk"
inherit kde4-base

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://kde/unstable/${PN}/${PV}/src/${P}.tar.bz2"
else
	KEYWORDS=""
fi

DESCRIPTION="KDE contact person abstraction library"
HOMEPAGE="https://projects.kde.org/projects/playground/network/libkpeople"

LICENSE="LGPL-2.1"
SLOT="4"
IUSE="debug examples test"

DEPEND="
	dev-libs/shared-desktop-ontologies
	dev-libs/soprano
	$(add_kdebase_dep nepomuk-core)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with examples)
	)

	kde4-base_src_configure
}
