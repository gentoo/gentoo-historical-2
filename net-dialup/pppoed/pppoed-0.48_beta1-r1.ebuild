# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-dialup/pppoed/pppoed-0.48_beta1-r1.ebuild,v 1.1 2001/04/24 16:00:48 achim Exp $

S=${WORKDIR}/pppoed-0.48b1/pppoed
DESCRIPTION="PPP over Ethernet"
SRC_URI="http://www.davin.ottawa.on.ca/pppoe/pppoed-0.48b1.tgz"
HOMEPAGE="http://www.davin.ottawa.on.ca/pppoe/"

DEPEND=">=sys-libs/glibc-2.1.3"

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/usr --sysconfdir=/etc/ppp/pppoed \
	--mandir=/usr/share/man
  try make
}

src_install() {                               
  cd ${S}
  try make DESTDIR=${D} install
  dodoc AUTHORS ChangeLog COPYING NEWS README*
  cd ..
  docinto docs
  dodoc docs/*
  docinto contrib
  dodoc contribs/*
}



