# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/psgml/psgml-1.2.2.ebuild,v 1.7 2002/07/11 06:30:19 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="PSGML is a GNU Emacs Major Mode for editing SGML and XML coded documents."
SRC_URI="http://ftp1.sourceforge.net/${PN}/${P}.tar.gz"
HOMEPAGE="http://psgml.sourceforge.net"

DEPEND="virtual/emacs"

src_compile() {

    ./configure --prefix=/usr --infodir=/usr/share/info --host=${CHOST} || die
    make || die

}

src_install () {

    make prefix=${D}/usr install || die
    dodir /usr/share/info
    make infodir=${D}/usr/share/info install-info || die

    dodoc ChangeLog README.psgml ${FILESDIR}/dot_emacs

}
