# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bruce A. Locke <blocke@shivan.org>

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="iplog is a TCP/IP traffic logger"
SRC_URI="http://download.sourceforge.net/ojnk/${P}.tar.gz"
HOMEPAGE="http://ojnk.sourceforge.net/"

DEPEND="virtual/glibc net-libs/libpcap"

src_compile() {

  try ./configure --prefix=/usr
  try make CFLAGS="${CFLAGS} -D_REENTRANT" all

}

src_install() {

  try make prefix=${D}/usr mandir=${D}/usr/share/man  install

  dodoc AUTHORS COPYING.* NEWS README TODO example-iplog.conf
}

