# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gle/gle-3.0.1-r2.ebuild,v 1.27 2005/02/27 03:29:46 geoman Exp $

DESCRIPTION="GL extrusion library"
HOMEPAGE="http://www.linas.org/gle"
SRC_URI="http://www.linas.org/gle/pub/gle-3.0.1.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~mips"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu
	virtual/glut"

src_compile() {
	econf --with-x || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	dohtml -r public_html
}
