# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/howto-pdf/howto-pdf-20021121.ebuild,v 1.2 2002/11/30 20:48:32 vapier Exp $

MY_P="Linux-pdf-HOWTOs-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="The LDP howtos, pdf format."
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
HOMEPAGE="http://www.linuxdoc.org"

SLOT="0"
LICENSE="GPL-2 LDP"
KEYWORDS="x86 ppc sparc sparc64"

src_install() {
	dodir /usr/share/doc/howto
	dodir /usr/share/doc/howto/pdf
	dosym /usr/share/doc/howto /usr/share/doc/HOWTO

	cd ${WORKDIR}
	insinto /usr/share/doc/howto/pdf
	doins *
}
