# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopengl/pyopengl-2.0.0.44.ebuild,v 1.7 2005/01/26 01:27:30 fserb Exp $

MY_P=${P/pyopengl/PyOpenGL}
S=${WORKDIR}/${MY_P}

inherit eutils distutils virtualx

DESCRIPTION="Python OpenGL bindings"
HOMEPAGE="http://pyopengl.sourceforge.net/"
SRC_URI="mirror://sourceforge/pyopengl/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="virtual/python
	virtual/glut
	virtual/x11
	virtual/opengl"

src_unpack() {
	unpack ${A}
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/config.diff
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/${P}-disable_togl.patch
}

src_compile() {
	export maketype="python"
	export python="virtualmake"
	distutils_src_compile
}

src_install() {
	export maketype="python"
	export python="virtualmake"
	distutils_src_install
}

pkg_setup() {
	CURRENT="$(opengl-update --get-implementation)"
	opengl-update xorg-x11
}

pkg_postinst() {
	opengl-update ${CURRENT}
}
