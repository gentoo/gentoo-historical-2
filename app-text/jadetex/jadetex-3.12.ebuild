# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/jadetex/jadetex-3.12.ebuild,v 1.7 2002/08/16 02:42:01 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="TeX macros used by Jade TeX output."
SRC_URI="mirror://sourceforge/jadetex/${P}.tar.gz"
HOMEPAGE="http://jadetex.sourceforge.net/"
SLOT="0"
LICENSE="freedist"

DEPEND=">=app-text/openjade-1.3.1
	>=app-text/tetex-1.0.7"

KEYWORDS="x86 ppc sparc sparc64"

src_compile() {

    emake || die

}

src_install () {

    make \
		DESTDIR=${D} \
		install || die

    dodoc ChangeLog*
    doman *.1
	
	dodir /usr/bin
    dosym /usr/bin/virtex /usr/bin/jadetex
    dosym /usr/bin/pdfvirtex /usr/bin/pdfjadetex
	
	dohtml -r doc

}

pkg_postinst () {
    mktexlsr
}
