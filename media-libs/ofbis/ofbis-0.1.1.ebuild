# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/ofbis/ofbis-0.1.1.ebuild,v 1.4 2002/07/23 00:12:55 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Framebuffer graphical library"
SRC_URI="ftp://ftp.nocrew.org/pub/osis/ofbis/${P}.tar.gz"
HOMEPAGE="http://www.nocrew.org/pub/ofbis"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="virtual/glibc"

src_compile() {

	./configure --prefix=/usr || die
	make CFLAGS="${CFLAGS}" all || die
}

src_install() {

	make DESTDIR=${D} install || die
	dodoc AUTHORS CREDITS DESIGN NEW OFBIS-VERSION README TODO \
		ChangeLog doc/ofbis.doc
}
