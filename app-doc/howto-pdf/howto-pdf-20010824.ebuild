# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/howto-pdf/howto-pdf-20010824.ebuild,v 1.7 2002/10/04 04:02:19 vapier Exp $

MY_P="Linux-pdf-HOWTOs-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="The LDP howtos, pdf format."

SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/gentoo-sources/${MY_P}.tar.gz"

HOMEPAGE="http://www.linuxdoc.org"

SLOT="0"
LICENSE="GPL"
KEYWORDS="x86 ppc sparc sparc64"


src_install () {
	
	dodir /usr/share/doc/howto
	dodir /usr/share/doc/howto/pdf
	dosym /usr/share/doc/howto /usr/share/doc/HOWTO
	
	cd ${WORKDIR}
	insinto /usr/share/doc/howto/pdf
	doins *
	
}
