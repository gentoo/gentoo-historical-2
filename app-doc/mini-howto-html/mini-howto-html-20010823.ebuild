# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Parag Mehta <pm@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-doc/mini-howto-html/mini-howto-html-20010823.ebuild,v 1.1 2001/08/23 10:32:23 pm Exp $

P="Linux-mini-html-HOWTOs"
S=${WORKDIR}/HOWTO/mini

DESCRIPTION="The LDP mini-howtos, html format."

SRC_URI="http://www.ibiblio.org/pub/Linux/docs/HOWTO/mini/other-formats/html/${P}-${PV}.tar.gz"

HOMEPAGE="http://www.linuxdoc.org"

src_install () {
    
    dodir /usr/share/doc/howto/mini
    dodir /usr/share/doc/howto/mini/html
    dosym /usr/share/doc/howto /usr/share/doc/HOWTO
    
    cd ${S}
    cp -R * ${D}/usr/share/doc/howto/mini/html
    
}
