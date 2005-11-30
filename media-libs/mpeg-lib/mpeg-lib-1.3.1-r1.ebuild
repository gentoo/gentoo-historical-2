# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/mpeg-lib/mpeg-lib-1.3.1-r1.ebuild,v 1.1 2001/02/22 16:44:19 achim Exp $

P=mpeg_lib-${PV}
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A lib for MPEG-1 video"
SRC_URI="ftp://ftp.mni.mcgill.ca/pub/mpeg/${A}"
HOMEPAGE="http://"

DEPEND="virtual/glibc"

src_compile() {

    try ./configure --prefix=/usr --host=${CHOST} --disable-dither
    try make

}

src_install () {

    try make prefix=${D}/usr install
    dodoc CHANGES README
    docinto txt
    dodoc doc/image_format.eps doc/mpeg_lib.*

}

