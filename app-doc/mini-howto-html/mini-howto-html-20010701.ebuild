# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $HEADER$

P="Linux-html-mini-HOWTOs"
S=${WORKDIR}/${P}

DESCRIPTION="The LDP mini-howtos, html format."

SRC_URI="http://www.ibiblio.org/pub/Linux/docs/HOWTO/mini/other-formats/html/${P}-${V}.tar.gz"

HOMEPAGE="http://www.linuxdoc.org"

src_install () {
    
    dodir /usr/share/doc/howto/mini
    dodir /usr/share/doc/howto/mini/html
    dosym /usr/share/doc/howto /usr/share/doc/HOWTO
    
    cd ${WORKDIR}
    insinto /usr/share/doc/howto/mini/html
    doins *
    
}