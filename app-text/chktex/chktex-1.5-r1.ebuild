# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/chktex/chktex-1.5-r1.ebuild,v 1.6 2002/10/04 05:03:27 vapier Exp $

S=${WORKDIR}/${P}
SRC_URI="http://www.ibiblio.org/pub/linux/distributions/gentoo/${P}.tar.gz"

HOMEPAGE="http://www.ifi.uio.no/~jensthi/chktex/ChkTeX.html"
SLOT="0"
LICENSE="GPL-2"
DESCRIPTION="Checks latex source for common mistakes"

DEPEND="app-text/tetex
	virtual/glibc
	sys-devel/ld.so
	sys-devel/perl
	sys-apps/groff
	app-text/latex2html"

KEYWORDS="x86 ppc sparc sparc64"

src_compile() {
    
    myconf="--prefix=/usr --host=${CHOST}"
    [ -n "$DEBUG" ] && myconf="$myconf --enable-debug-info" || myconf="$myconf --disable-debug-info"
    
    ./configure ${myconf} || die
    
    emake || die

}

src_install () {

    make prefix=${D}/usr install || die

}

