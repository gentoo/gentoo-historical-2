# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-doc/howto-ps/howto-ps-20020328.ebuild,v 1.3 2002/07/21 02:51:19 cardoe Exp $

MY_P="Linux-ps-HOWTOs-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="The LDP howtos, postscript format."

SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/gentoo-sources/${MY_P}.tar.gz"

HOMEPAGE="http://www.linuxdoc.org"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 ppc sparc sparc64"

src_install () {
    
    dodir /usr/share/doc/howto
    dodir /usr/share/doc/howto/ps
    dosym /usr/share/doc/howto /usr/share/doc/HOWTO
    
    cd ${WORKDIR}
    insinto /usr/share/doc/howto/ps
    doins *
    
}
