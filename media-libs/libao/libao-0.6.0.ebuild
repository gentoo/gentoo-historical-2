# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-libs/libao/libao-0.6.0.ebuild,v 1.2 2002/07/11 06:30:39 drobbins Exp $


A=${PN}-${PV}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="the audio output library"
SRC_URI="http://www.vorbis.com/files/beta4/unix/${A}"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"
DEPEND=">=media-sound/esound-0.2.22"

src_compile() {
    try ./configure --prefix=/usr --host=${CHOST} --enable-shared --enable-static
    try make
}

src_install () {
    try make DESTDIR=${D} install
    
    echo "Removing docs installed by make install"
    rm -rf ${D}/usr/share/doc
    dodoc AUTHORS CHANGES COPYING README TODO
    dodoc doc/API doc/DRIVERS doc/USAGE doc/WANTED
}
