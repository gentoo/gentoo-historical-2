# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcdaudio/libcdaudio-0.99.6.ebuild,v 1.4 2002/07/16 11:36:47 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="a library of cd audio related routines"
SRC_URI="http://download.sourceforge.net/libcdaudio/${P}.tar.gz"
HOMEPAGE="http://libcdaudio.sourceforge.net/"
DEPEND="virtual/glibc"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 ppc"

src_compile() {
    #export CFLAGS="`echo $CFLAGS | sed -e 's:-march=[a-z0-9]*::'`"
    ./configure --prefix=/usr --host=${CHOST} --enable-threads || die
    emake || die
}

src_install () {
    make DESTDIR=${D} install || die
    dodoc AUTHORS COPYING ChangLog NEWS README README.BeOS README.OSF1 TODO
}
