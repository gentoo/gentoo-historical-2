# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wv2/wv2-0.0.7.ebuild,v 1.1 2003/02/25 16:58:25 verwilst Exp $

S=${WORKDIR}/${P}

DESCRIPTION="Excellent MS Word filter lib, used in most Office suites"
SRC_URI="mirror://sourceforge/wvware/${P}.tar.bz2"
HOMEPAGE="http://www.wvware.com"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=gnome-extra/libgsf-1.7.2
	>=media-libs/freetype-2.1
	sys-libs/zlib
	media-libs/libpng"
	
RDEPEND="media-gfx/imagemagick"		

src_compile() {
	
	econf || die #--with-docdir=/usr/share/doc/${PF} || die 

	make || die
}

src_install () {

	einstall || die
	
}
