# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/whois/whois-4.5.0-r1.ebuild,v 1.1 2000/08/09 22:58:29 achim Exp $

P=whois-4.5.0
A=whois_4.5.0.tar.gz
S=${WORKDIR}/whois-4.4.15
CATEGORY="net-misc"
DESCRIPTION="Whois Client"
SRC_URI="http://www.linux.it/~md/software/${A}"

src_unpack() {
  unpack ${A}
  cd ${S}
  cp Makefile Makefile.orig
  sed -e "s/-O2/$CFLAGS/" Makefile.orig > Makefile
  cd po
  cp Makefile Makefile.orig
  sed -e "s:/usr/bin/install:install:" Makefile.orig > Makefile

}
src_compile() {                           
  cd ${S}
  make
  make mkpasswd
}

src_install() {                               
  cd ${S}
  dodir /usr/bin
  dodir /usr/man/man1
  dodir /usr/share/locale
  make BASEDIR=${D} prefix=/usr install
  prepman
  dobin mkpasswd
  doman mkpasswd.1
  dodoc README TODO debian/changelog debian/copyright

}




