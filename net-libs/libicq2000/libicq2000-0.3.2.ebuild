# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libicq2000/libicq2000-0.3.2.ebuild,v 1.1 2002/08/04 15:00:49 phoenix Exp $

S=${WORKDIR}/${P}
DESCRIPTION="ICQ 200x compatible ICQ libraries."
SRC_URI="mirror://sourceforge/libicq2000/${P}.tar.gz"
HOMEPAGE="http://ickle.sf.net"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="x86"

DEPEND="=dev-libs/libsigc++-1.0*"

src_compile() {
	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--localstatedir=/var/lib \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die "emake failed"

}

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS TODO
}
