# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/sslwrap/sslwrap-2.0.5-r1.ebuild,v 1.7 2002/04/27 21:09:36 seemant Exp $

S=${WORKDIR}/${PN}${PV/.0./0}
DESCRIPTION="TSL/SSL - Port Wrapper"
SRC_URI="http://www.rickk.com/sslwrap/${PN}.tar.gz"
HOMEPAGE="http://www.rickk.com/sslwrap/"

DEPEND=">=sys-libs/glibc-2.1.3
	>=dev-libs/openssl-0.9.6"

src_unpack () {
	unpack ${A}
	cd ${S}
	cp Makefile Makefile.orig
	sed -e "s/-O2/${CFLAGS}/" \
			-e "s:/usr/local/ssl/include:/usr/include/openssl:" Makefile.orig > Makefile
	cp ${FILESDIR}/*.c ${S}
}

src_compile() {													 
	emake || die
}

src_install() {															 
	cd ${S}
	into /usr
	dosbin sslwrap
	dodoc README
	dohtml -r ./
}
