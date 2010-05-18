# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopengl/pyopengl-3.0.1.ebuild,v 1.3 2010/05/18 13:35:41 hwoarang Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
PYTHON_USE_WITH="tk"
PYTHON_USE_WITH_OPT="tk"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

MY_PN="PyOpenGL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python OpenGL bindings"
HOMEPAGE="http://pyopengl.sourceforge.net/ http://pypi.python.org/pypi/PyOpenGL"
SRC_URI="http://pypi.python.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
	mirror://sourceforge/pyopengl/${MY_P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="tk"

RDEPEND="virtual/glut
	virtual/opengl
	x11-libs/libXi
	x11-libs/libXmu
	tk? ( dev-tcltk/togl )"
DEPEND="${RDEPEND}
	dev-python/setuptools"
RESTRICT_PYTHON_ABIS="2.4 3.*"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="OpenGL"
