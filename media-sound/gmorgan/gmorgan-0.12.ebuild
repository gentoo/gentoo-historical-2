# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gmorgan/gmorgan-0.12.ebuild,v 1.1 2003/08/15 02:50:33 g2boojum Exp $

IUSE=""

DESCRIPTION="An opensource software rhythm station."
HOMEPAGE="http://personal.telefonica.terra.es/web/soudfontcombi/"
SRC_URI="http://personal.telefonica.terra.es/web/soudfontcombi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=x11-libs/fltk-1.1.2
	virtual/alsa"

src_compile() {
	econf || die "configure failed"
     
	emake || die "compile failed"
}

src_install() {
         make prefix=${D}/usr install || die

         dodoc AUTHORS INSTALL NEWS README 
}
