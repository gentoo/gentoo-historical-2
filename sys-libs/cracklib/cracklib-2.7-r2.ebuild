# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-libs/cracklib/cracklib-2.7-r2.ebuild,v 1.4 2002/07/09 12:51:08 aliz Exp $

A=cracklib2_${PV}.orig.tar.gz
A0=${P}-redhat.patch
S=${WORKDIR}/cracklib,${PV}
DESCRIPTION="Cracklib"
SRC_URI="ftp://ftp.debian.org/debian/dists/potato/main/source/utils/${A}"
LICENSE="CRACKLIB"
KEYWORDS="x86"
SLOT="0"

DEPEND="virtual/glibc"

src_unpack() {

  unpack ${A}
  cd ${S}
  patch -p1 <${FILESDIR}/${A0}
  patch -p1 <${FILESDIR}/${P}-gentoo.diff

}

src_compile() {

  # Parallel make does not work for 2.7
  try make all

}

src_install() {

  dodir /usr/lib
  dodir /usr/sbin
  dodir /usr/include
  dodir /usr/share/cracklib

  try make DESTDIR=${D} install

  mv ${D}/usr/lib ${D}
  preplib /

  dodoc HISTORY LICENCE MANIFEST POSTER README

}
