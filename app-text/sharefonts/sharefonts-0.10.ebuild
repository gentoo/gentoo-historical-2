# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/sharefonts/sharefonts-0.10.ebuild,v 1.1 2000/10/29 20:36:59 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/sharefont
DESCRIPTION="A Collection of True Type Fonts"
SRC_URI="ftp://ftp.gimp.org/pub/gimp/fonts/${A}"
HOMEPAGE="http://www.gimp.org"


src_compile() {

    cd ${S}

}

src_install () {

    cd ${S}
    dodir /usr/X11R6/lib/X11/fonts/sharefont
    cp -a * ${D}/usr/X11R6/lib/X11/fonts/sharefont
    rm  ${D}/usr/X11R6/lib/X11/fonts/sharefont/README
    dodoc README

}

