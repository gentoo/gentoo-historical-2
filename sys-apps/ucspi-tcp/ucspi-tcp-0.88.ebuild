# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-tcp/ucspi-tcp-0.88.ebuild,v 1.2 2000/11/27 15:12:34 achim Exp $

DESCRIPTION="Collection of tools for managing UNIX services"
SRC_URI="http://cr.yp.to/ucspi-tcp/ucspi-tcp-0.88.tar.gz"
HOMEPAGE="http://cr.yp.to/ucspi-tcp/"
S=${WORKDIR}/${P}
DEPEND=">=sys-libs/glibc-2.1.3"

src_unpack() {

  unpack ucspi-tcp-0.88.tar.gz
  echo $WORKDIR/${P}
  echo $S
  echo "gcc ${CFLAGS}" > conf-cc
  echo "gcc -s" > conf-ld

}

src_compile() {                           
  cd ${S}
  try make
}

src_install() {                               
  cd ${S}
  into /usr
  for i in tcpserver tcprules tcprulescheck argv0 recordio tcpclient *\@ tcpcat mconnect mconnect-io addcr delcr fixcrio rblsmtpd
  do
    dobin $i
  done
  dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION
}



