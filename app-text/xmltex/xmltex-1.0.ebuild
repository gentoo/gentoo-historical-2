# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/xmltex/xmltex-1.0.ebuild,v 1.4 2002/04/27 09:36:11 seemant Exp $

MY_P="base"
S=${WORKDIR}/${MY_P}
DESCRIPTION="A namespace-aware XML parser written in Tex"
SRC_URI="ftp://ftp.tex.ac.uk/tex-archive/macros/xmltex/${MY_P}.tar.gz"
HOMEPAGE="http://users.ox.ac.uk/~rahtz/passivetex/"

DEPEND="app-text/tetex"
SLOT="0"

src_compile() {
	cp ${FILESDIR}/${P}-Makefile Makefile
	make || die
}

src_install () {

	make DESTDIR=${D} install || die
	dodir /usr/bin
	cd ${D}/usr/bin
	ln -sf /usr/bin/virtex xmltex
	ln -sf /usr/bin/pdfvirtex pdfxmltex
}

pkg_postinst() {
	if [ -e /usr/bin/mktexlsr ]
	then
		/usr/bin/mktexlsr
	fi
}
