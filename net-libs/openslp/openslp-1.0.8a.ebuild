# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/openslp/openslp-1.0.8a.ebuild,v 1.7 2002/10/19 21:07:54 cselkirk Exp $

S=${WORKDIR}/${P}
DESCRIPTION="An open-source implementation of Service Location Protocol"
SRC_URI="mirror://sourceforge/openslp/${P}.tar.gz"
HOMEPAGE="http://www.openslp.org"

DEPEND="virtual/glibc"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc sparc64 ppc"

src_compile() {
	
	econf || die
    make || die

}

src_install () {

    einstall || die
    dodoc AUTHORS FAQ COPYING ChangeLog NEWS README* THANKS 
    rm -rf ${D}/usr/doc
    dohtml -r .

}
