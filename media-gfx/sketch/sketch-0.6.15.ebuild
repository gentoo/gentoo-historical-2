# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sketch/sketch-0.6.15.ebuild,v 1.3 2003/03/19 20:39:57 hanno Exp $

IUSE="nls"
S=${WORKDIR}/${P}
DESCRIPTION="Interactive X11 vector drawing program"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://sketch.sourceforge.net/"
DEPEND=">=dev-python/Imaging-1.1.2-r1
	dev-lang/tk"
RDEPEND="nls? ( sys-devel/gettext )"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

src_compile() {
	use nls && useopts="${useopts} --with-nls"
	./setup.py configure ${useopts} || die "setup.py configure failed"
	./setup.py build || die "setup.py build failed"
}

src_install () {
	./setup.py install --prefix=/usr --dest-dir=${D}
	assert "setup.py install failed"

	newdoc Pax/README README.pax
	newdoc Pax/COPYING COPYING.pax
	newdoc Filter/COPYING COPYING.filter
	newdoc Filter/README README.filter
	dodoc Examples Doc Misc
	dodoc README INSTALL BUGS CREDITS COPYING TODO PROJECTS FAQ NEWS
}
