# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/xmps/xmps-0.1.3-r1.ebuild,v 1.3 2000/09/15 20:09:06 drobbins Exp $

P=xmps-0.1.3
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="X Movie Player System"
SRC_URI="http://www-eleves.enst-bretagne.fr/~chavarri/xmps/sources/${A}"
HOMEPAGE="http://www-eleves.enst-bretagne.fr/~chavarri/xmps/"

src_compile() {

    cd ${S}
    try ./configure --prefix=/usr/X11R6 --host=${CHOST} \
	--with-catgets
    try make

}

src_install () {

    cd ${S}
    try make DESTDIR=${D} install
    dodoc AUTHORS ChangeLog COPYING NEWS README TODO

}



