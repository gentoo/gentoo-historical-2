# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/sablotron/sablotron-0.90.ebuild,v 1.2 2002/07/11 06:30:19 drobbins Exp $

MY_P="Sablot-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="An XSLT Parser in C++"
SRC_URI="http://www.gingerall.com/perl/rd?url=sablot/${MY_P}.tar.gz"
HOMEPAGE="http://www.gingerall.com/charlie-bin/get/webGA/act/sablotron.act"

DEPEND=">=sys-devel/gcc-2.95.2 
		>=dev-libs/expat-1.95.1 
		virtual/glibc"


src_compile() {
    ./configure --prefix=/usr --host=${CHOST} || die
    pmake || die
}

src_install () {
    make prefix=${D}/usr install || die
    dodoc README* RELEASE
    dodoc src/TODO
}
