# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpdump/tcpdump-3.5-r1.ebuild,v 1.2 2000/08/16 04:38:12 drobbins Exp $

P=tcpdump-3.5
A=${P}.tar.gz
S=${WORKDIR}/tcpdump_3_5rel2
DESCRIPTION="A Tool for network monitoring and data acquisition"
SRC_URI="http://www.tcpdump.org/release/${A}
	 http://www.jp.tcpdump.org/release/${A}"
HOMEPAGE="http://www.tcpdump.org/"


src_compile() {                           
  cd ${S}
  ./configure --host=${CHOST} --prefix=/usr
  make
}

src_install() {                               
  cd ${S}
  into /usr
  dobin tcpdump
  doman tcpdump.1
  dodoc README FILES VERSION CHANGES
}



