# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/mini-howto-text/mini-howto-text-20021121.ebuild,v 1.2 2002/11/30 21:39:36 vapier Exp $

MY_P="Linux-mini-HOWTOs-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="The LDP mini-howtos, text format."
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"
HOMEPAGE="http://www.linuxdoc.org"

SLOT="0"
LICENSE="GPL-2 LDP"
KEYWORDS="x86 ppc sparc sparc64"

src_install() {
	dodir /usr/share/doc/howto/mini
	dodir /usr/share/doc/howto/mini/text
	dosym /usr/share/doc/howto /usr/share/doc/HOWTO

	cd ${WORKDIR}
	insinto /usr/share/doc/howto/mini/text
	doins *
}
