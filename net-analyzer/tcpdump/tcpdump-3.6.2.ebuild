# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpdump/tcpdump-3.6.2.ebuild,v 1.1 2002/05/09 17:30:04 spider Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="A Tool for network monitoring and data acquisition"
SRC_URI="http://www.tcpdump.org/release/${A}
	 http://www.jp.tcpdump.org/release/${A}"
HOMEPAGE="http://www.tcpdump.org/"

DEPEND="virtual/glibc
	ssl? ( >=dev-libs/openssl-0.6.9 )
	>=net-libs/libpcap-0.6.2"

RDEPEND="virtual/glibc
	ssl? ( >=dev-libs/openssl-0.6.9 )"

src_compile() {
  local myconf
  if [ -z "`use ssl`" ] ; then
    myconf="--without-crypto"
  fi
  try ./configure --host=${CHOST} --prefix=/usr --enable-ipv6 $myconf
#--disable-ipv6
  try make CCOPT="$CFLAGS"
}

src_install() {                               
  into /usr
  dobin tcpdump
  doman tcpdump.1
  dodoc README FILES VERSION CHANGES
}



