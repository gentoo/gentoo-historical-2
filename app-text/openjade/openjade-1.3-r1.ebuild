# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/openjade/openjade-1.3-r1.ebuild,v 1.1 2000/08/07 15:31:45 achim Exp $

P=openjade-1.3
A=${P}.tar.gz
S=${WORKDIR}/${P}
CATEGORY="app-text"
DESCRIPTION="Jade is an implemetation of DSSSL - an ISO standard for formatting SGML (and XML) documents"
SRC_URI="http://download.sourceforge.net/openjade/"${A}
HOMEPAGE="http://openjade.sourceforge.net"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  SGML_PREFIX=/usr/share/sgml
  ./configure --host=${CHOST} --prefix=/usr --enable-http \
	--enable-default-catalog=$SGML_PREFIX/dtd/docbook/docbook.cat:$SGML_PREFIX/stylesheets/docbook/catalog:$SGML_PREFIX/jade/dsssl/catalog:
	--enable-default-search-path=/usr/share/sgml/stylesheets/docbook/:/usr/share/sgml/dtd/docbook/:/usr/share/sgml/jade/dsssl/:
  make
}

src_install() {                               
  cd ${S}
  dodir /usr
  dodir /usr/lib
  make prefix=${D}/usr install
  dosym openjade /usr/bin/jade
  dodir /usr/share/sgml/jade
  rm ${D}usr/share/builtins.dsl
  for i in unicode dsssl pubtext
  do
    cp -af $i ${D}/usr/share/sgml/jade
  done
  dodoc COPYING NEWS README VERSION
  docinto html/doc
  dodoc doc/*.htm
  docinto html/jadedoc
  dodoc jadedoc/*.htm
  docinto html/jadedoc/images
  dodoc jadedoc/images/*
}



