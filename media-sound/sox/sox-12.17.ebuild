# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/sox/sox-12.17.ebuild,v 1.1 2000/09/10 15:17:29 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The swiss army knife of sound processing programs"
SRC_URI="http://download.sourceforge.net/sox/${A}"
HOMEPAGE="http://home.sprynet.com/~cgabwell/sox.html"


src_compile() {

    cd ${S}
    ./configure --prefix=/usr --host=${CHOST} \
	 --enable-fast-ulaw --enable-fast-alaw --with-alsa-dsp
    make

}

src_install () {

    cd ${S}
    into /usr
    dobin sox
    doman sox.1
    dodoc Changelog Copyright README TODO *.txt

}




