# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/adasockets/adasockets-1.7.ebuild,v 1.2 2003/09/08 07:20:54 msterret Exp $

DESCRIPTION="An Interface to BSD sockets from Ada (TCP, UDP and multicast)."
SRC_URI="http://www.rfc1149.net/download/adasockets/${P}.tar.gz"
HOMEPAGE="http://www.rfc1149.net/devel/adasockets/"
LICENSE="GMGPL"

DEPEND="dev-lang/gnat"
RDEPEND=""
SLOT="0"
IUSE=""
KEYWORDS="~x86"

inherit gnat

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--libdir=/usr/lib/ada/adalib \
		--includedir=/usr/lib/ada/adainclude \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	emake || die
}

src_install () {
	cd ${S}
	#doins copies symlinks as regular files, resorting to manual cp
	dodir /usr/lib/ada/adalib/adasockets
	cp -d src/.libs/lib*.so* ${D}/usr/lib/ada/adalib/adasockets
	chmod 0755 ${D}/usr/lib/ada/adalib/adasockets/lib*.so*
	insinto /usr/lib/ada/adalib/adasockets
	doins src/.libs/lib*.a
	chmod 0644 ${D}/usr/lib/ada/adalib/adasockets/lib*.a
	doins src/sockets*.ali

	insinto /usr/lib/ada/adainclude/adasockets
	doins src/sockets*.ads

	dodoc AUTHORS COPYING INSTALL NEWS README
	dodoc doc/adasockets.pdf doc/adasockets.ps
	doinfo doc/adasockets.info
	doman man/adasockets-config.1
	dobin src/adasockets-config
}
