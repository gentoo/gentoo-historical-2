# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvb/libdvb-0.2.3.ebuild,v 1.3 2003/09/06 23:59:48 msterret Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="mpegtools package for manipulation of various MPEG file formats"
HOMEPAGE="http://www.metzlerbros.org/dvb/"
SRC_URI="http://www.metzlerbros.org/dvb/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=media-tv/linuxtv-dvb-1.0.0_pre2"

src_compile() {
    # setting $ARCH cuz it uses ${ARCH}g++
    ARCH='' emake
}

src_install() {
    # no proper Makefile (no DESTDIR)
    mv ${S}/Makefile ${S}/Makefile_orig
    sed s%/usr/local/lib/%${D}/usr/lib/% ${S}/Makefile_orig > ${S}/Makefile
    dodir /usr/lib
    make install || die

    # install headers
    dodir /usr/include/libdvb
    insinto /usr/include/libdvb
    doins ${S}/*.h ${S}/*.hh

    # docs
    dodoc ${S}/README

    # config stuff
    dodoc ${S}/dvbrc.*
}

