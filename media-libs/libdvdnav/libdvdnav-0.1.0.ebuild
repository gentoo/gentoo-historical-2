# Copyright 1999-2002 Arcady Genkin <agenkin@thpoon.com>
# Distributed under the terms of the GNU General Public License, v2
# Maintainer: Arcady Genkin <agenkin@thpoon.com>
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdnav/libdvdnav-0.1.0.ebuild,v 1.4 2002/05/27 17:27:38 drobbins Exp $

DESCRIPTION="Library for DVD navigation tools."
HOMEPAGE="http://sourceforge.net/projects/dvd/"

SRC_URI="mirror://sourceforge/dvd/${P}.tar.gz"
S=${WORKDIR}/${P}

LICENSE="GPL"

DEPEND="media-libs/libdvdread"

src_compile() {

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING INSTALL NEWS README
}
