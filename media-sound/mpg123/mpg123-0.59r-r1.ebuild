# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Id: mpg123-0.59r-r1.ebuild,v 1.1 2002/04/27 10:58:46 pvdabeel Exp $

P=mpg123-0.59r
A=${P}.tar.gz
S=${WORKDIR}/${P}

DESCRIPTION="Real Time mp3 player"
SRC_URI="http://www.mpg123.de/mpg123/${A}"
HOMEPAGE="http://www.mpg123.de/"

DEPEND="virtual/glibc"

src_unpack () {
    unpack ${A}
    cd ${S}
    cp Makefile Makefile.orig
    sed -e "s:-O2 -m486:${CFLAGS}:" Makefile.orig > Makefile
}

src_compile() {
	MAKEOPT=""
	MAKESTYLE=""

	SYSTEM_ARCH=`echo $ARCH |\
	  sed -e s/[i]*.86/i386/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/`
	if [ -z "$SYSTEM_ARCH" ]
	then
		SYSTEM_ARCH=`uname -m |\
	    sed -e s/[i]*.86/i386/ -e s/sun4u/sparc64/ -e s/arm.*/arm/ -e s/sa110/arm/`
	fi 

	case $SYSTEM_ARCH in 
	  ppc) 
	   MAKESTYLE="-ppc";;
	  i386)
	   MAKESTYLE="-i486";;
	  sparc64)
	   ;;
	  arm)
	   ;; 
	esac

    try make linux${MAKESTYLE}${MAKEOPT}
}

src_install () {
    into /usr
    dobin mpg123
    doman mpg123.1
    dodoc BENCHMARKING BUGS CHANGES COPYING JUKEBOX README* TODO
}


