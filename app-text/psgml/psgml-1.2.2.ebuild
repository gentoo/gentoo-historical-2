# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Your Name <your email>
# $Header: /var/cvsroot/gentoo-x86/app-text/psgml/psgml-1.2.2.ebuild,v 1.5 2002/04/27 23:08:35 bangert Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="PSGML is a GNU Emacs Major Mode for editing SGML and XML coded documents."
SRC_URI="http://ftp1.sourceforge.net/${PN}/${A}"
HOMEPAGE="http://psgml.sourceforge.net"

DEPEND="virtual/emacs"

src_compile() {

    try ./configure --prefix=/usr --infodir=/usr/share/info --host=${CHOST}
    try make

}

src_install () {

    try make prefix=${D}/usr install
    dodir /usr/share/info
    try make infodir=${D}/usr/share/info install-info

    dodoc ChangeLog README.psgml ${FILESDIR}/dot_emacs

}

