# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xdelta/xdelta-1.1.3.ebuild,v 1.10 2003/07/16 13:42:33 pvdabeel Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Computes changes between binary or text files and creates deltas"
SRC_URI="mirror://sourceforge/xdelta/${P}.tar.gz"
HOMEPAGE="http://xdelta.sourceforge.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND="=dev-libs/glib-1.2*
	>=sys-libs/zlib-1.1.4"

src_compile() {
	econf || die "./configure failed"
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS ChangeLog COPYING NEWS README
}
