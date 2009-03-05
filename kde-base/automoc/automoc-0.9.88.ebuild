# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/automoc/automoc-0.9.88.ebuild,v 1.4 2009/03/05 16:04:56 mr_bones_ Exp $

EAPI="2"

MY_PN="automoc4"
MY_P="$MY_PN-${PV}"

inherit cmake-utils flag-o-matic

DESCRIPTION="KDE Meta Object Compiler"
HOMEPAGE="http://www.kde.org"
SRC_URI="mirror://kde/stable/${MY_PN}/${PV}/${MY_P}.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core:4"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	if [[ ${ELIBC} == "uclibc" ]]; then
		append-flags -pthread
	fi
}
