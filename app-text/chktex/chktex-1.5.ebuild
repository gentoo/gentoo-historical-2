# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/chktex/chktex-1.5.ebuild,v 1.2 2001/08/01 18:04:02 danarmak Exp $

S=${WORKDIR}/${P}
SRC_URI="http://www.ibiblio.org/pub/linux/distributions/gentoo/${P}.tar.gz"

HOMEPAGE="http://www.ifi.uio.no/~jensthi/chktex/ChkTeX.html"
DESCRIPTION="Checks latex source for common mistakes"

DEPEND="app-text/tetex
	virtual/glibc
	sys-devel/ld.so
	sys-devel/perl
	sys-apps/groff
	app-text/latex2html"

src_compile() {
    
    confopts="--infodir=/usr/share/info --mandir=/usr/share/man --prefix=/usr --host=${CHOST} --disable-debug-info"
    
    try ./configure ${confopts}
    
    try make

}

src_install () {

    try make prefix=${D}/usr install

}

pkg_postinst () {
    
    echo "
    If you're using ChkTeX with LyX, rerun the lyx configure script
    (available as Edit -> Reconfigure in the lyx menus), and restart
    lyx.
    "
    
}