# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/sgml2x/sgml2x-0.11-r1.ebuild,v 1.5 2000/11/01 04:44:13 achim Exp $

P=sgml2x-0.11
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Frontend for jade and jadetex"
SRC_URI="ftp://sgml2x.sourceforge.net/pub/sgml2x/"${A}
HOMEPAGE="http://sgml2x.sourceforge.net/"

DEPEND=">=sys-devel/perl-5"

src_unpack() {
  unpack ${A}
  cd ${S}
  cp Makefile Makefile.orig
  sed -e "s:perl Makefile.PL:perl Makefile.PL $PERLINSTALL:" Makefile.orig > Makefile
}

src_compile() {                           
  cd ${S}
  try make
}

src_install() {                               
  cd ${S}
  dodir /usr/bin
  dodir /etc
  make prefix=${D}/usr sysconfdir=${D}/etc install
  dodoc README
  docinto html
  dodoc sgml2x.html doc/*.html doc/*.gif
}




