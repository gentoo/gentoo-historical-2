# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-text/sharefonts/sharefonts-0.10-r1.ebuild,v 1.3 2002/07/11 06:30:19 drobbins Exp $

S=${WORKDIR}/sharefont
DESCRIPTION="A Collection of True Type Fonts"
SRC_URI="ftp://ftp.gimp.org/pub/gimp/fonts/${P}.tar.gz"
HOMEPAGE="http://www.gimp.org"

src_install () {

	dodir /usr/X11R6/lib/X11/fonts/sharefont
	cp -a * ${D}/usr/X11R6/lib/X11/fonts/sharefont
	rm  ${D}/usr/X11R6/lib/X11/fonts/sharefont/README
	dodoc README

}

