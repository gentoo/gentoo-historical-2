# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qt-opengl/qt-opengl-4.4.0_beta1.ebuild,v 1.1 2008/03/05 23:10:07 ingmar Exp $

EAPI="1"
inherit qt4-build

DESCRIPTION="The OpenGL module for the Qt toolkit."
HOMEPAGE="http://www.trolltech.com/"

LICENSE="|| ( QPL-1.0 GPL-3 GPL-2 )"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="+qt3support"

DEPEND="~x11-libs/qt-gui-${PV}
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

QT4_TARGET_DIRECTORIES="src/opengl"
QCONFIG_ADD="opengl"
QCONFIG_DEFINE="QT_OPENGL"

pkg_setup() {
	use qt3support && QT4_BUILT_WITH_USE_CHECK="${QT4_BUILT_WITH_USE_CHECK}
		~x11-libs/qt-core-${PV} qt3support"
	qt4-build_pkg_setup
}

src_compile() {
	local myconf
	myconf="${myconf} -opengl
		$(qt_use qt3support)"

	# Not building tools/designer/src/plugins/tools/view3d as it's commented out of the build in the source
	qt4-build_src_compile
}
