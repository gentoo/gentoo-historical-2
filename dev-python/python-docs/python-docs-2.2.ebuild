# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-docs/python-docs-2.2.ebuild,v 1.2 2002/07/11 06:30:24 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="HTML documentation for Python"
SRC_URI="http://www.python.org/ftp/python/doc/2.2p1/html-2.2p1.tar.bz2"
HOMEPAGE="http://www.python.org/doc/2.2/"

src_unpack() {
	mkdir ${S}
	cd ${S} 
	unpack ${A} 
}

src_install() {
	docinto html
	cp -R ${S}/* ${D}/usr/share/doc/${P}/html
	chown -R root.root ${D}/usr/share/doc/${P}/html
	find ${D}/usr/share/doc/${P}/html -type d -exec chmod 0755 \{\} \;
	find ${D}/usr/share/doc/${P}/html -type f -exec chmod 0644 \{\} \;
}
