# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Parag Mehta <pm@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-doc/mini-howto-pdf/mini-howto-pdf-20010823.ebuild,v 1.1 2001/08/23 10:32:23 pm Exp $

P="Linux-mini-pdf-HOWTOs"
S=${WORKDIR}/${P}

DESCRIPTION="The LDP mini-howtos, pdf format."

SRC_URI="http://www.ibiblio.org/pub/Linux/docs/HOWTO/mini/other-formats/pdf/${P}-${PV}.tar.gz"

HOMEPAGE="http://www.linuxdoc.org"

src_install () {
    
    dodir /usr/share/doc/howto/mini
    dodir /usr/share/doc/howto/mini/pdf
    dosym /usr/share/doc/howto /usr/share/doc/HOWTO
    
    cd ${WORKDIR}
    insinto /usr/share/doc/howto/mini/pdf
    doins *
    
}
