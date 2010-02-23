# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/polkit-qt/polkit-qt-0.95.1.ebuild,v 1.2 2010/02/23 08:06:46 josejx Exp $

EAPI="2"

inherit cmake-utils

MY_P="${P/qt/qt-1}"

DESCRIPTION="PolicyKit Qt4 API wrapper library."
HOMEPAGE="http://kde.org/"
SRC_URI="mirror://kde/stable/polkit-qt-1/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="debug examples"

COMMON_DEPEND="
	>=sys-auth/polkit-0.95
	x11-libs/qt-gui[dbus]
"
DEPEND="${COMMON_DEPEND}
	kde-base/automoc
"
RDEPEND="${COMMON_DEPEND}
	examples? ( !sys-auth/policykit-qt[examples] )
"

DOCS="AUTHORS README README.porting TODO"

S="${WORKDIR}/${MY_P}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build examples)
	)

	cmake-utils_src_configure
}
