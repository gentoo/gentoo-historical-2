# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/adaopengl/adaopengl-0.12.ebuild,v 1.4 2003/10/06 00:18:40 dholm Exp $

inherit gnat

S="${WORKDIR}/${P}"
DESCRIPTION="This is an Ada-binding to OpenGL and some of it's related libraries."
SRC_URI="mirror://sourceforge/adaopengl/${P}.tar.bz2"
HOMEPAGE="http://adaopengl.sourceforge.net/"
LICENSE="BSD"

IUSE=""
SLOT="0"
KEYWORDS="x86 ~ppc"
DEPEND="dev-lang/gnat
	>=dev-ada/adabindx-0.7.2"
RDEPEND="virtual/opengl"

src_compile() {
	# This should not be here ;)
	rm ${S}/adaopengl/adagl.ads

	emake || die
}

src_install () {
	make PREFIX=${D}/usr install || die

	# Install documentation.
	dodoc Changelog COPYING Readme TODO
}
