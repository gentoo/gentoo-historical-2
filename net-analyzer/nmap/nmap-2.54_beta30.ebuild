# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nmap/nmap-2.54_beta30.ebuild,v 1.1 2002/01/26 09:28:46 blocke Exp $


P=nmap-2.54BETA30
A=${P}.tgz
S=${WORKDIR}/${P}
DESCRIPTION="Portscanner"
SRC_URI="http://www.insecure.org/nmap/dist/"${A}
HOMEPAGE="http://www.insecure.org/nmap/"

DEPEND="virtual/glibc
	gtk? ( >=x11-libs/gtk+-1.2.10-r4 )"

src_compile() {                           
  try ./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man --enable-ipv6
  if [ "`use gtk`" ] ; then
    try make
  else
    try make nmap
  fi
}

src_install() {                               

  try make prefix=${D}/usr mandir=${D}/usr/share/man install

  dodoc CHANGELOG COPYING HACKING README*
  cd docs
  dodoc *.txt
  docinto html
  dodoc *.html
}



