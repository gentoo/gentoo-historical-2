# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bruce A. Locke <blocke@shivan.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/grip/grip-2.96-r1.ebuild,v 1.1 2001/09/14 23:01:59 lordjoe Exp $


A=${P}.tgz
S=${WORKDIR}/${P}
DESCRIPTION="GTK+ based Audio CD Ripper"
SRC_URI="http://www.nostatic.org/grip/${A}"
HOMEPAGE="http://www.nostatic.org/grip"

DEPEND="media-sound/cdparanoia"

# Seems to be fixed...
#src_unpack() {
#
#   # author forgot to gzip his tgz file... sigh
#   cd ${WORKDIR}
#   tar xvf ${DISTDIR}/${P}.tgz
#
#}

src_compile() {

   # grip doesn't have a nice configure script and requires some
   # symlink love to build

   cd ${S}

   mkdir cdparanoia
   mkdir cdparanoia/interface
   mkdir cdparanoia/paranoia
   ln -s /usr/lib/libcdda* cdparanoia/interface/
   ln -s /usr/lib/libcdda* cdparanoia/paranoia/
   ln -s /usr/include/*cdda* cdparanoia/interface/
   ln -s /usr/include/*cdda* cdparanoia/paranoia/
   ln -s /usr/include/utils.h cdparanoia/utils.h

   # apply CFLAGS
   mv Makefile Makefile.old
   sed -e "s/-Wall/-Wall ${CFLAGS}/" -e "s/PREFIX=\/usr/PREFIX=\/usr\/X11R6/" Makefile.old > Makefile

   try make all

}

src_install () {
    cd ${S}

    dodir /usr/X11R6/bin

    cp ${S}/grip ${D}/usr/X11R6/bin
    cp ${S}/gcd ${D}/usr/X11R6/bin

    dodir /usr/X11R6/man/man1

    gzip ${S}/grip.1
    cp ${S}/grip.1.gz ${D}/usr/X11R6/man/man1
    cp ${S}/grip.1.gz ${D}/usr/X11R6/man/man1/gcd.1.gz

    dodoc README LICENSE TODO CREDITS CHANGES

    insinto /usr/X11R6/include/X11/pixmaps
    doins pixmaps/*.xpm

}
