# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-video/xanim/xanim-2.80.1-r1.ebuild,v 1.2 2002/07/11 06:30:42 drobbins Exp $

A="xanim2801.tar.gz xa1.0_cyuv_linuxELFg21.o.gz xa2.0_cvid_linuxELFg21.o.gz
   xa2.1_iv32_linuxELFg21.o.gz"
S=${WORKDIR}/xanim2801
DESCRIPTION="XAnim"
SRC_URI="ftp://xanim.va.pubnix.com/xanim2801.tar.gz
	 ftp://xanim.va.pubnix.com/modules/xa1.0_cyuv_linuxELFg21.o.gz
	 ftp://xanim.va.pubnix.com/modules/xa2.0_cvid_linuxELFg21.o.gz
	 ftp://xanim.va.pubnix.com/modules/xa2.1_iv32_linuxELFg21.o.gz"
HOMEPAGE="http://xanim.va.pubnix.com"

DEPEND="virtual/glibc virtual/x11 >=sys-libs/zlib-1.1.3"

src_unpack() {
  unpack xanim2801.tar.gz
  mkdir ${S}/mods
  cd ${S}/mods
  cp ${DISTDIR}/xa1.0_cyuv_linuxELFg21.o.gz .
  gunzip xa1.0_cyuv_linuxELFg21.o.gz
  cp ${DISTDIR}/xa2.0_cvid_linuxELFg21.o.gz .
  gunzip xa2.0_cvid_linuxELFg21.o.gz
  cp ${DISTDIR}/xa2.1_iv32_linuxELFg21.o.gz .
  gunzip xa2.1_iv32_linuxELFg21.o.gz
  sed -e "s:-O2:${CFLAGS}:" ${FILESDIR}/Makefile > ${S}/Makefile
}
src_compile() {

    try make

}

src_install () {

    into /usr
    dobin xanim
    newman docs/xanim.man xanim.1
    insinto /usr/lib/xanim/mods
    doins mods/*
    dodoc README
    dodoc docs/README.* docs/*.readme docs/*.doc
}

