# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyside/pyside-0.2.3-r1.ebuild,v 1.1 2010/02/01 20:34:42 ayoy Exp $

EAPI="2"

inherit cmake-utils

MY_P="${PN}-qt4.6+${PV}"

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://www.pyside.org/"
SRC_URI="http://www.pyside.org/files/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/boost-1.41.0[python]
	~dev-python/boostpythongenerator-0.3.3
	>=x11-libs/qt-core-4.5.0
	>=x11-libs/qt-assistant-4.5.0
	>=x11-libs/qt-gui-4.5.0
	>=x11-libs/qt-opengl-4.5.0
	|| ( >=x11-libs/qt-phonon-4.5.0 media-sound/phonon )
	>=x11-libs/qt-script-4.5.0
	>=x11-libs/qt-sql-4.5.0
	>=x11-libs/qt-svg-4.5.0
	>=x11-libs/qt-webkit-4.5.0
	>=x11-libs/qt-xmlpatterns-4.5.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-qtscripttools.patch"
	sed -e 's:cmake-2\.6:cmake:' \
	    -i data/CMakeLists.txt || die "sed failed"

	# bug 301747
	sed -e 's:Boost 1\.38:Boost 1\.41:' \
		-i CMakeLists.txt || die "sed failed"
	sed -e 's:${QTVERSION} GREATER 4\.5\.0:EXISTS ${QT_LIBRARY_DIR}/libQtMultimedia.so:' \
		-i PySide/CMakeLists.txt || die "sed failed"
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog || die "dodoc failed"
}
