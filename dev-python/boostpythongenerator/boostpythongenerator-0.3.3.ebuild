# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/boostpythongenerator/boostpythongenerator-0.3.3.ebuild,v 1.2 2010/06/16 19:38:17 ayoy Exp $

EAPI="2"

inherit cmake-utils

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="~dev-python/apiextractor-${PV}
	~dev-python/generatorrunner-${PV}
	>=x11-libs/qt-core-4.5.0"
RDEPEND="${DEPEND}
	!dev-python/shiboken"

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog || die "dodoc failed"
}
