# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/mini-howto-pdf/mini-howto-pdf-20020328.ebuild,v 1.6 2002/11/30 21:30:25 vapier Exp $

MY_P="Linux-mini-pdf-HOWTOs-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="The LDP mini-howtos, pdf format."
SRC_URI="http://www.ibiblio.org/pub/Linux/distributions/gentoo/gentoo-sources/${MY_P}.tar.gz"
HOMEPAGE="http://www.linuxdoc.org/"

SLOT="0"
LICENSE="GPL-2 LDP"
KEYWORDS="x86 ppc sparc sparc64"

src_install() {
	dodir /usr/share/doc/howto/mini
	dodir /usr/share/doc/howto/mini/pdf
	dosym /usr/share/doc/howto /usr/share/doc/HOWTO

	cd ${WORKDIR}
	insinto /usr/share/doc/howto/mini/pdf
	doins *
}
