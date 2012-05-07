# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwtplot3d/qwtplot3d-0.2.7-r2.ebuild,v 1.2 2012/05/07 09:14:26 ago Exp $

EAPI=4

inherit qt4-r2

DESCRIPTION="Qt4/OpenGL-based 3D widget library for C++"
HOMEPAGE="http://qwtplot3d.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="ZLIB"
SLOT="0"
IUSE="doc examples"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~x86"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/gl2ps"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-profile.patch
	"${FILESDIR}"/${PN}-examples.patch
	"${FILESDIR}"/${PN}-doxygen.patch
	"${FILESDIR}"/${PN}-sys-gl2ps.patch
	"${FILESDIR}"/${PN}-gcc44.patch
	"${FILESDIR}"/${PN}-qt48.patch
	)

src_prepare() {
	qt4-r2_src_prepare
	cat >> ${PN}.pro <<-EOF
		target.path = /usr/$(get_libdir)
		headers.path = /usr/include/${PN}
		headers.files = \$\$HEADERS
		INSTALLS = target headers
	EOF
}

src_compile() {
	qt4-r2_src_compile
	 if use doc ; then
		 cd doc
		 doxygen Doxyfile.doxygen || die "doxygen failed"
	 fi
}

src_install () {
	qt4-r2_src_install
	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
	use doc && dohtml -r doc/web/doxygen/*
}
