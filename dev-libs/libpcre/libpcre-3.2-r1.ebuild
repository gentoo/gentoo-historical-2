# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpcre/libpcre-3.2-r1.ebuild,v 1.4 2000/11/01 04:44:15 achim Exp $

P=libpcre-3.2
A=pcre-3.2.tar.gz
S=${WORKDIR}/pcre-3.2
DESCRIPTION="Perl compatible regular expressions"
SRC_URI="ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/"${A}

DEPEND=">=sys-apps/bash-2.04
	>=sys-libs/glibc-2.1.3"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/usr
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/usr install
  prepman
  dodoc AUTHORS COPYING ChangeLog LICENCE NEWS NON-UNIX-USE README
  dodoc doc/*.txt doc/Tech.Notes
  docinto html
  dodoc doc/*.html
  
}




