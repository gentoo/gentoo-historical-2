# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/qimageblitz/qimageblitz-0.0.4.ebuild,v 1.6 2009/04/11 15:51:37 armin76 Exp $

EAPI="1"

inherit cmake-utils eutils

DESCRIPTION="interim image effect library that people can use until KDE 4.1"
HOMEPAGE="http://websvn.kde.org/trunk/kdesupport/qimageblitz/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="3dnow altivec debug mmx sse sse2"

DEPEND="|| ( x11-libs/qt-gui:4
	>=x11-libs/qt-4.2.0:4 )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/qimageblitz-9999-exec-stack.patch
}

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_has 3dnow 3DNOW)
		$(cmake-utils_has altivec ALTIVEC)
		$(cmake-utils_has mmx MMX)
		$(cmake-utils_has sse SSE)
		$(cmake-utils_has sse2 SSE2)"

	cmake-utils_src_compile
}
