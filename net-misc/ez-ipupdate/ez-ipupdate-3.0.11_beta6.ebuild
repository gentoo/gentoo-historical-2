# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/ez-ipupdate/ez-ipupdate-3.0.11_beta6.ebuild,v 1.1 2002/02/24 23:11:37 gbevin Exp $

S="${WORKDIR}/${PN}-3.0.11b6"
SRC_URI="http://gusnet.cx/proj/ez-ipupdate/dist/${PN}-3.0.11b6.tar.gz"
HOMEPAGE="http://gusnet.cx/proj/ez-ipupdate"
DESCRIPTION="Dynamic DNS client for lots of dynamic dns services"

DEPEND="virtual/glibc"

src_compile() {

	cd ${S}
	./configure --host=${CHOST} --prefix=/usr || die	
	emake || die
}

src_install(){

	make DESTDIR=${D} install || die
	for f in example*.conf
	do
		mv ${f} ${f}_orig
		sed -e "s#/usr/local/bin/ez-ipupdate#/usr/bin/ez-ipupdate#g" \
			${f}_orig > ${f}
		dodoc ${f}
	done
	dodoc CHANGELOG COPYING INSTALL README
}
