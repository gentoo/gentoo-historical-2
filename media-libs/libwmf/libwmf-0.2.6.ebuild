# Copyright 20022 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License
# $Header: /var/cvsroot/gentoo-x86/media-libs/libwmf/libwmf-0.2.6.ebuild,v 1.1 2002/07/10 22:06:39 george Exp $

#The configure script finds the 5.50 ghostscript Fontmap file while run.
#This will probably work, especially since the real one (6.50) in this case
#is empty. However beware in case there is any trouble


S=${WORKDIR}/${P}
DESCRIPTION="library for converting WMF files"
SRC_URI="mirror://sourceforge/wvware/${P}.tar.gz"
HOMEPAGE="http://www.wvware.com/libwmf.html"

DEPEND="virtual/glibc
	>=sys-devel/gcc-2.95.2
	>=app-text/ghostscript-6.50 
	dev-libs/expat
	dev-libs/libxml2
	>=media-libs/freetype-2.0.1
	sys-libs/zlib
	media-libs/libpng
	media-libs/jpeg"
# plotutils are not really supported yet, so looks like that's it
	
RDEPEND=""

SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"

src_compile() {
	
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--with-gsfontdir=/usr/share/ghostscript/fonts \
		--with-fontdir=/usr/share/libwmf/fonts/ \
		--with-docdir=${D}/usr/share/doc/${PF} || die "./configure failed"

	make || die
}

src_install () {
    make \
        prefix=${D}/usr \
        mandir=${D}/usr/share/man \
        infodir=${D}/usr/share/info \
		fontdir=${D}/usr/share/libwmf/fonts/ \
        install || die

	dodoc README AUTHORS COPYING CREDITS ChangeLog NEWS TODO
}
