# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Joe Bormolini <lordjoe@gentoo.org>

A=unrar250.zip
S=${WORKDIR}/${P}
DESCRIPTION="Uncompress rar files"
SRC_URI="ftp://ftp.elf.stuba.sk/pub/pc/pack/${A}"
HOMEPAGE="ftp://ftp.elf.stuba.sk/pub/pc/pack"

DEPEND="virtual/glibc"
RDEPEND="virtual/glibc"
# Might be more depends... probably not, though

src_compile() {
# Many many warnings... but seems to work okay  
  cd src
  mv Makefile Makefile.orig
  sed -e "s:-O2:${CFLAGS}:" Makefile.orig > Makefile
  try make
}

src_install() {  
  cd ${S}
  dobin src/unrar
  dodoc readme.txt license.txt
}



