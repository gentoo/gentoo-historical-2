# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/metamail/metamail-2.7-r1.ebuild,v 1.2 2000/08/16 04:37:55 drobbins Exp $

P=metamail-2.7
A=mm2.7.tar.Z
S=${WORKDIR}/mm2.7/src
DESCRIPTION="Metamail"
SRC_URI="ftp://thumper.bellcore.com/pub/nsb/"${A}

src_unpack() {
  unpack ${A}
  cd ${S}
  cp Makefile Makefile.orig
  sed -e "s:^CFLAGS =.*:CFLAGS = -fsigned-char -g -pipe -DLINUX -I \. ${CFLAGS} -Bstatic:" Makefile.orig > Makefile
  cd metamail
  cp Makefile Makefile.orig
  sed -e "s/-ltermcap/-lncurses/" Makefile.orig > Makefile
  cd ../richmail
  cp Makefile Makefile.orig
  sed -e "s/-ltermcap/-lncurses/" Makefile.orig > Makefile
}

src_compile() {                           
  cd ${S}
  make
  make -C fonts
}

src_install() {                               
  cd ${S}
  into /usr
  dobin bin/*
  doman man/*
  dodoc CREDITS README mailers.txt
  insinto /usr/X11R6/lib/X11/fonts/misc
  doins fonts/*.pcf
}



