# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygame/pygame-1.2.ebuild,v 1.10 2003/02/13 11:37:06 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="python bindings to sdl and other libs that facilitate game production"
SRC_URI="http://www.pygame.org/ftp/${P}.tar.gz"
HOMEPAGE="http://www.pygame.org/"

#build-time dependencies
DEPEND="virtual/python
	>=media-libs/libsdl-1.2.0
	>=media-libs/sdl-ttf-2.0.3
	>=media-libs/sdl-image-1.2.0
	>=media-libs/sdl-mixer-1.2.0
	>=dev-python/Numeric-19.0.0
	>=media-libs/smpeg-0.4.4-r1"

SLOT="0"
KEYWORDS="x86 sparc alpha"
LICENSE="LGPL-2.1"

src_compile() {
	python setup.py build || die
}

src_install () {
	python setup.py install --prefix=${D}/usr || die
	
	dodoc README.TXT WHATSNEW
	dodir /usr/share/doc/${P}/html/
	cp -a docs/* ${D}/usr/share/doc/${P}/html/
	cp -a examples ${D}/usr/share/doc/${P}/
}

