# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/psgml/psgml-1.2.2.ebuild,v 1.13 2003/02/13 09:43:14 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="PSGML is a GNU Emacs Major Mode for editing SGML and XML coded documents."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://psgml.sourceforge.net"
KEYWORDS="x86 sparc "
SLOT="0"
LICENSE="GPL-2"

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
