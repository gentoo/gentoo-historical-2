# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-doc/howto-html/howto-html-20010823.ebuild,v 1.4 2002/07/11 06:30:11 drobbins Exp $

MY_P="Linux-html-HOWTOs-${PV}"
S=${WORKDIR}/HOWTO

DESCRIPTION="The LDP howtos, html format."

SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/gentoo-sources/${MY_P}.tar.gz"

HOMEPAGE="http://www.linuxdoc.org"


src_install () {
    
    dodir /usr/share/doc/howto
    dodir /usr/share/doc/howto/html
    dosym /usr/share/doc/howto /usr/share/doc/HOWTO
    
    cd ${S}
    cp -R * ${D}/usr/share/doc/howto/html
    
}
