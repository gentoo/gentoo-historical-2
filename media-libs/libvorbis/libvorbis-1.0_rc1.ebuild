# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Peter Gavin <pbg1854@garnet.acns.fsu.edu>
# $Header: /var/cvsroot/gentoo-x86/media-libs/libvorbis/libvorbis-1.0_rc1.ebuild,v 1.1 2001/06/21 15:27:00 achim Exp $


A=libvorbis-1.0rc1.tar.gz
S=${WORKDIR}/libvorbis-1.0rc1
DESCRIPTION="the Ogg Vorbis sound file format library"
SRC_URI="http://www.vorbis.com/files/rc1/unix/${A}"
HOMEPAGE="http://www.xiph.org/ogg/vorbis/index.html"

DEPEND=">=media-libs/libogg-1.0_rc1"

src_compile() {
    export CFLAGS="${CFLAGS/-march=*/}"
    #unset CXXFLAGS
    try ./configure --prefix=/usr --host=${CHOST}
    try make
}

src_install () {

    try make DESTDIR=${D} install

    echo "Removing docs installed by make install"
    rm -rf ${D}/usr/share/doc

    dodoc AUTHORS COPYING README todo.txt
    docinto txt
    dodoc doc/*.txt
    docinto html
    dodoc doc/*.{html,png}
    docinto html/vorbisenc
    dodoc doc/vorbisenc/*.{css,html}
    docinto html/vorbisfile
    dodoc doc/vorbisfile/*.{css,html}
}

