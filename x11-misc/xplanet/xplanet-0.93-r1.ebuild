# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Kalen Petersen <kalenp@cs.washington.edu>
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xplanet/xplanet-0.93-r1.ebuild,v 1.1 2002/03/27 23:31:11 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A program to render images of the earth into the X root window"
SRC_URI="http://prdownloads.sourceforge.net/xplanet/${P}.tar.gz"
HOMEPAGE="http://xplanet.sourceforge.net/"

DEPEND="virtual/x11"

src_compile() {
        local myconf
        if [ "`use opengl`" ]
        then
                myconf="--with-gl --with-glut --with-animation"
        else
                myconf="--with-gl=no --with-glut=no --with-animation=no"
        fi
        if [ "`use gif`" ]
        then
                myconf="$myconf --with-gif"
        else
                myconf="$myconf --with-gif=no"
        fi
        if [ "`use X`" ]
        then
                myconf="$myconf --with-x"
        else
                myconf="$myconf --with-x=no"
        fi

        ./configure --prefix=/usr \
		--with-freetype=no \
		--mandir=/usr/share/man \
		$myconf || die
        # xplanet doesn't like to build parallel
        # This fix taken from the gimp ebuild
        make || die
}

src_install () {
        make prefix=${D}/usr mandir=${D}/usr/share/man install || die
}

