# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp/gimp-1.1.25.ebuild,v 1.6 2000/09/15 20:09:00 drobbins Exp $

P=gimp-1.1.25
A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="GIMP"
SRC_URI="ftp://ftp.insync.net/pub/mirrors/ftp.gimp.org/gimp/v1.1/v1.1.25/"${A}
HOMEPAGE="http://www.gimp.org"

src_unpack() {

  unpack ${A}
  cd ${S}
  cp configure configure.orig
  sed -e "s#--writemakefile \$perl_prefix#--writemakefile \$perl_prefix $PERLINSTALL#" configure.orig > configure
   
}

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/usr/X11R6
  try make 
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/usr/X11R6 install
  prepman /usr/X11R6
  dodoc AUTHORS COPYING ChangeLog* *MAINTAINERS README* TODO
  dodoc docs/*.txt docs/*.ps docs/Wilber* docs/quick_reference.tar.gz
  docinto html/libgimp
  dodoc devel-docs/libgimp/html/*.html
  docinto devel
  dodoc devel-docs/*.txt
}










