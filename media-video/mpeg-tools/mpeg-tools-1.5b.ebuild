# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/mpeg-tools/mpeg-tools-1.5b.ebuild,v 1.4 2000/11/02 08:31:51 achim Exp $

P=mpeg-tools-1.5b
A=mpeg_encode-1.5b-src.tar.gz
S=${WORKDIR}/mpeg_encode
DESCRIPTION="Tools for MPEG video"
SRC_URI="ftp://mm-ftp.cs.berkeley.edu/pub/multimedia/mpeg/encode/${A}"
HOMEPAGE="http://bmrc.bercley.edu/research/mpeg/mpeg_encode.html"

DEPEND=">=sys-libs/glibc-2.1.3"

src_unpack () {
    unpack ${A}
    cd ${S}
    cp libpnmrw.c libpnmrw.c.orig
    sed -e "s:extern char\* sys_errlist:extern __const char \*__const sys_errlist:" \
	libpnmrw.c.orig > libpnmrw.c
}
src_compile() {

    cd ${S}
    try make
    cd ../convert
    try make
    cd mtv
    try make
}

src_install () {

    cd ${S}
    into /usr
    dobin mpeg_encode
    doman docs/*.1
    dodoc BUGS CHANGES COPYRIGHT README TODO VERSION
    dodoc docs/EXTENSIONS docs/INPUT.FORMAT docs/*.param docs/param-summary
    docinto examples
    dodoc examples/*
    cd ../convert
    dobin eyuvtojpeg eyuvtoppm jmovie2jpeg mpeg_demux ppmtoeyuv mtv/movieToVid
    
    

}


