# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/ghostscript/ghostscript-6.50-r2.ebuild,v 1.6 2001/06/07 14:13:37 blutgens Exp $

GPV="4.1.1"
A="${P}.tar.gz ghostscript-fonts-std-6.0.tar.gz print-${GPV}.tar.gz"
A1=jpegsrc.v6b.tar.gz
A2=zlib-1.1.3.tar.gz
A3=libpng-1.0.11.tar.gz

S=${WORKDIR}/gs${PV}
DESCRIPTION="Aladin Ghostscript"
SRC_URI="http://download.sourceforge.net/ghostscript/${P}.tar.gz
	 http://download.sourceforge.net/gs-fonts/ghostscript-fonts-std-6.0.tar.gz
	 http://download.sourceforge.net/gimp-print/print-${GPV}.tar.gz
	ftp://ftp.uu.net/graphics/jpeg/${A2}
	ftp://swrinde.nde.swri.edu/pub/png/src/${A3}"

DEPEND="virtual/glibc
	=media-libs/libpng-1.0.11
	=media-libs/jpeg-6b-r2
	=sys-libs/zlib-1.1.3-r2
	virtual/x11"

src_unpack() {
  unpack ${A}
  cd ${S}
  patch -p0 < ${FILESDIR}/${P}-time_.h-gentoo.diff
  #touch src/gdevstp-print.h
  mkdir zlib
  cd zlib
  unpack ${A2}
  cd ..
  mkdir jpeg
  cd jpeg
  unpack ${A1}
  cd ..
  mkdir libpng
  cd libpng
  unpack ${A3}
  cd ../src
  cp ${O}/files/all-arch.mak all-arch.mak
  cd ${WORKDIR}/print-${GPV}/Ghost
  cp *.c *.h ${S}/src
  cat contrib.mak.addon >> ${S}/src/contrib.mak
  cd ${S}/src
  cp unix-gcc.mak unix-gcc.mak.orig
  sed -e "s:^DEVICE_DEVS6=:DEVICE_DEVS6=\$\(DD\)stp\.dev :" \
	unix-gcc.mak.orig > unix-gcc.mak
}

src_compile() {

  cd ${S}/src
  cp all-arch.mak all-arch.mak.orig
  sed -e "s:^SRCDIR.*:SRCDIR = ${S}:" all-arch.mak.orig > all-arch.mak
  cp unix-gcc.mak unix-gcc.mak.orig
  sed -e "s:-O2:${CFLAGS}:" \
      unix-gcc.mak.orig > unix-gcc.mak
  cd ..
  try make -f src/all-arch.mak linux prefix=/usr
  cd ${WORKDIR}/print-${GPV}/Ghost
  try make

}

src_install() {

  dodir /usr/share/man/man1
  dobin bin/gs
  try make -f src/all-arch.mak prefix=${D}/usr BINDIR=${D}/usr/bin man1dir=${D}/usr/share/man/man1 install
  rm -rf ${D}/usr/man
  cd ${WORKDIR}
  cp -a fonts ${D}/usr/share/ghostscript
  cd ${S}

  dodir /usr/share/doc/${PF}
  rm -rf ${D}/usr/share/ghostscript/${PV}/doc
  dodoc doc/README doc/PUBLIC
  docinto html
  dodoc doc/*.html doc/*.htm
  insinto /usr/share/emacs/site-lisp
  doins doc/gsdoc.el

  cd ${WORKDIR}/print-${GPV}/Ghost
  dobin escputil
  docinto stp
  dodoc README* COPYING ChangeLog
  
}




