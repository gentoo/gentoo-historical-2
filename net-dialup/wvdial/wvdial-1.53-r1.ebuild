# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/wvdial/wvdial-1.53-r1.ebuild,v 1.2 2003/02/13 13:56:16 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Excellent program which automatically configures your PPP session"
SRC_URI="http://open.nit.ca/download/${P}.tar.gz"
HOMEPAGE="http://open.nit.ca/"

DEPEND="net-libs/wvstreams"
RDEPEND="${DEPEND} net-dialup/ppp"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 sparc "

src_unpack() {

	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-crypt.patch || die "Patch failed"

}

src_compile() {
	
	cp Makefile Makefile.orig
	sed -e "s:PREFIX=/usr/local:PREFIX=/usr:" \
		Makefile.orig > Makefile
}

src_install() {
	cp Makefile Makefile.orig
	sed -e "s:PPPDIR=/etc/ppp/peers:PPPDIR=${D}/etc/ppp/peers:" \
		Makefile.orig > Makefile

	make \
		PREFIX=${D}/usr \
		install || die

	dodoc ANNOUNCE CHANGES COPYING.LIB README 
	dodoc debian/copyright debian/changelog
}
