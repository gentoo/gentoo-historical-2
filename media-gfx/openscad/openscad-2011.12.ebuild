# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/openscad/openscad-2011.12.ebuild,v 1.2 2012/08/04 14:14:26 kensington Exp $

EAPI="2"

inherit qt4-r2

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org/"
SRC_URI="https://github.com/downloads/openscad/openscad/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

CDEPEND="media-gfx/opencsg
	sci-mathematics/cgal
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	dev-cpp/eigen
	dev-libs/gmp
	dev-libs/mpfr
	dev-libs/boost
	sys-libs/glibc
"
DEPEND="${CDEPEND} sys-devel/gcc"
RDEPEND="${CDEPEND}"

src_prepare() {
	#Use our CFLAGS (specifically don't force x86)
	sed -i "s/QMAKE_CXXFLAGS_RELEASE = .*//g" ${PN}.pro

	sed -i "s/\/usr\/local/\/usr/g" ${PN}.pro
}
