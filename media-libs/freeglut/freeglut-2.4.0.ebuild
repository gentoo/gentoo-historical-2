# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/freeglut/freeglut-2.4.0.ebuild,v 1.9 2006/05/21 19:30:53 nixnut Exp $

inherit eutils

DESCRIPTION="A completely OpenSourced alternative to the OpenGL Utility Toolkit (GLUT) library"
HOMEPAGE="http://freeglut.sourceforge.net/"
SRC_URI="mirror://sourceforge/freeglut/${P}.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ppc-macos ppc64 sparc ~x86"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu
	!media-libs/glut"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	# fixes bug #97390
	epatch ${FILESDIR}/${P}-macos.patch
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO
	docinto doc
	dohtml -r doc/*.html doc/*.png
}
